// MoodMeal JavaScript
class MoodMeal {
    constructor() {
        this.apiBase = '../backend/api/';
        this.selectedMood = null;
        this.recipes = [];
        this.moods = [];
        this.init();
    }

    init() {
        this.loadMoods();
        this.bindEvents();
    }

    // API Calls
    async apiCall(endpoint, options = {}) {
        try {
            const response = await fetch(this.apiBase + endpoint, options);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return await response.json();
        } catch (error) {
            console.error('API call failed:', error);
            this.showMessage('Something went wrong. Please try again.', 'error');
            return null;
        }
    }

    // Load all moods
    async loadMoods() {
        const moods = await this.apiCall('get-moods.php');
        if (moods) {
            this.moods = moods;
            this.renderMoodSelector();
        }
    }

    // Load recipes by mood or all recipes
    async loadRecipes(moodId = null) {
        this.showLoading();
        const endpoint = moodId ? `get-recipes.php?mood_id=${moodId}` : 'get-recipes.php';
        const recipes = await this.apiCall(endpoint);
        if (recipes) {
            this.recipes = recipes;
            this.renderRecipes();
        }
        this.hideLoading();
    }

    // Load single recipe
    async loadRecipe(recipeId) {
        const recipe = await this.apiCall(`get-recipes.php?id=${recipeId}`);
        return recipe;
    }

    // Favorites removed: addToFavorites and loadFavorites removed

    // Submit new recipe
    async submitRecipe(formData) {
        const result = await this.apiCall('add-recipe.php', {
            method: 'POST',
            body: formData
        });
        
        if (result && result.success) {
            this.showMessage(result.message, 'success');
            // Reset form
            const form = document.getElementById('add-recipe-form');
            if (form) form.reset();
        }
    }

    // Render Functions
    renderMoodSelector() {
        const container = document.getElementById('mood-selector');
        if (!container) return;

        container.innerHTML = this.moods.map(mood => `
            <div class="mood-card" data-mood-id="${mood.id}" style="border-color: ${mood.color}">
                <div class="mood-icon">${this.getMoodIcon(mood.name)}</div>
                <h3>${mood.name}</h3>
                <p>${mood.description}</p>
            </div>
        `).join('');

        // Add click handlers
        container.querySelectorAll('.mood-card').forEach(card => {
            card.addEventListener('click', () => {
                // Remove active class from all cards
                container.querySelectorAll('.mood-card').forEach(c => c.classList.remove('active'));
                // Add active class to clicked card
                card.classList.add('active');
                
                const moodId = card.dataset.moodId;
                this.selectedMood = moodId;
                this.loadRecipes(moodId);
            });
        });
    }

    renderRecipes() {
        const container = document.getElementById('recipes-container');
        if (!container) return;

        if (this.recipes.length === 0) {
            container.innerHTML = '<div class="container"><p>No recipes found. Try a different mood or add some recipes!</p></div>';
            return;
        }

        container.innerHTML = `
            <div class="container">
                <div class="recipes-grid">
                    ${this.recipes.map(recipe => this.renderRecipeCard(recipe)).join('')}
                </div>
            </div>
        `;
    }

    renderRecipeCard(recipe) {
        return `
            <div class="recipe-card">
                <div class="recipe-image">
                    ${recipe.image_url ? `<img src="${recipe.image_url}" alt="${recipe.title}" style="width:100%;height:100%;object-fit:cover;">` : '🍽️'}
                </div>
                <div class="recipe-content">
                    <h3 class="recipe-title">${recipe.title}</h3>
                    <p class="recipe-description">${recipe.description || 'Delicious recipe'}</p>
                    <div class="recipe-meta">
                        <span>⏱️ ${(recipe.prep_time || 0) + (recipe.cook_time || 0)} min</span>
                        <span>🍽️ ${recipe.servings || 1} servings</span>
                    </div>
                    ${recipe.mood_name ? `<span class="mood-tag" style="background-color: ${recipe.mood_color || '#ffb347'}">${recipe.mood_name}</span>` : ''}
                    <div style="margin-top: 1rem;">
                        <button onclick="window.location.href='recipe-details.html?id=${recipe.id}'" class="btn btn-small">View Recipe</button>
                        <button onclick="app.addToFavorites(${recipe.id})" class="btn btn-secondary btn-small">💖 Save</button>
                    </div>
                </div>
            </div>
        `;
    }

    // (Favorites removal via backend removed — favourites page uses client-side removal)

    // Utility Functions
    getMoodIcon(moodName) {
        const icons = {
            'Happy': '😊',
            'Sad': '😢',
            'Energetic': '⚡',
            'Relaxed': '😌',
            'Romantic': '💕',
            'Stressed': '😰'
        };
        return icons[moodName] || '🍽️';
    }

    showLoading() {
        const container = document.getElementById('recipes-container');
        if (container) {
            container.innerHTML = '<div class="loading">Loading delicious recipes... 🍳</div>';
        }
    }

    hideLoading() {
        // Loading is hidden when content is rendered
    }

    showMessage(message, type = 'success') {
        // Create message element
        const messageEl = document.createElement('div');
        messageEl.className = `message ${type}`;
        messageEl.textContent = message;

        // Add to page
        const main = document.querySelector('main');
        if (main) {
            main.insertBefore(messageEl, main.firstChild);
            
            // Remove after 5 seconds
            setTimeout(() => {
                messageEl.remove();
            }, 5000);
        }
    }

    bindEvents() {
        // Recipe form submission
        const addRecipeForm = document.getElementById('add-recipe-form');
        if (addRecipeForm) {
            addRecipeForm.addEventListener('submit', (e) => {
                e.preventDefault();
                const formData = new FormData(addRecipeForm);
                this.submitRecipe(formData);
            });
        }

        // Load all recipes on homepage
        const loadAllBtn = document.getElementById('load-all-recipes');
        if (loadAllBtn) {
            loadAllBtn.addEventListener('click', () => {
                // Remove active class from mood cards
                document.querySelectorAll('.mood-card').forEach(c => c.classList.remove('active'));
                this.selectedMood = null;
                this.loadRecipes();
            });
        }
    }
}

// Recipe Details Page Specific Functions
class RecipeDetails {
    constructor() {
        this.apiBase = '../backend/api/';
        this.loadRecipeDetails();
    }

    async loadRecipeDetails() {
        const urlParams = new URLSearchParams(window.location.search);
        const recipeId = urlParams.get('id');
        
        if (!recipeId) {
            window.location.href = 'index.html';
            return;
        }

        try {
            const response = await fetch(`${this.apiBase}get-recipes.php?id=${recipeId}`);
            const recipe = await response.json();
            
            if (recipe && !recipe.error) {
                this.renderRecipeDetails(recipe);
            } else {
                document.getElementById('recipe-content').innerHTML = '<p>Recipe not found.</p>';
            }
        } catch (error) {
            console.error('Error loading recipe:', error);
            document.getElementById('recipe-content').innerHTML = '<p>Error loading recipe.</p>';
        }
    }

    renderRecipeDetails(recipe) {
        const container = document.getElementById('recipe-content');
        if (!container) return;

        // Split ingredients and instructions by newlines
        const ingredients = recipe.ingredients.split('\n').filter(i => i.trim());
        const instructions = recipe.instructions.split('\n').filter(i => i.trim());

        container.innerHTML = `
            <div class="container">
                <div class="recipe-header">
                    <h1>${recipe.title}</h1>
                    <p>${recipe.description || 'A delicious recipe to try!'}</p>
                    ${recipe.mood_name ? `<span class="mood-tag" style="background-color: ${recipe.mood_color || '#ffb347'}">${recipe.mood_name}</span>` : ''}
                </div>
                
                <div class="recipe-info">
                    <div class="info-card">
                        <h3>Prep Time</h3>
                        <p>${recipe.prep_time || 0} min</p>
                    </div>
                    <div class="info-card">
                        <h3>Cook Time</h3>
                        <p>${recipe.cook_time || 0} min</p>
                    </div>
                    <div class="info-card">
                        <h3>Servings</h3>
                        <p>${recipe.servings || 1}</p>
                    </div>
                    <div class="info-card">
                        <h3>Total Time</h3>
                        <p>${(recipe.prep_time || 0) + (recipe.cook_time || 0)} min</p>
                    </div>
                </div>

                <div class="ingredients-list">
                    <h3>Ingredients</h3>
                    <ul>
                        ${ingredients.map(ingredient => `<li>${ingredient}</li>`).join('')}
                    </ul>
                </div>

                <div class="instructions-list">
                    <h3>Instructions</h3>
                    <ol>
                        ${instructions.map(instruction => `<li>${instruction}</li>`).join('')}
                    </ol>
                </div>

                <div style="text-align: center; margin-top: 2rem;">
                    <button onclick="addToFavorites(${recipe.id})" class="btn">💖 Add to Favorites</button>
                    <a href="index.html" class="btn btn-secondary">← Back to Recipes</a>
                </div>
            </div>
        `;
    }
    // Add recipe to favorites (keeps backend call for add behavior)
    async addToFavorites(recipeId) {
        try {
            const formData = new FormData();
            formData.append('recipe_id', recipeId);
            formData.append('action', 'add');

            const result = await this.apiCall('save-favorite.php', {
                method: 'POST',
                body: formData
            });

            if (result) {
                if (result.success) {
                    this.showMessage(result.message, 'success');
                } else if (result.message) {
                    this.showMessage(result.message, 'error');
                } else if (result.error) {
                    this.showMessage(result.error, 'error');
                }
            }
        } catch (error) {
            console.error('Error adding to favorites:', error);
            this.showMessage('Failed to add to favorites. Please try again.', 'error');
        }
    }
}

// Favorites removed: global addToFavorites removed

// Global functions
async function addToFavorites(recipeId) {
    const formData = new FormData();
    formData.append('recipe_id', recipeId);
    formData.append('action', 'add');
    
    try {
        const response = await fetch('../backend/api/save-favorite.php', {
            method: 'POST',
            body: formData
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const result = await response.json();
        
        if (result.success) {
            alert('✅ ' + result.message);
        } else if (result.message) {
            alert('ℹ️ ' + result.message);
        } else if (result.error) {
            alert('❌ ' + result.error);
        } else {
            alert('❌ Failed to add to favorites');
        }
    } catch (error) {
        console.error('Error adding to favorites:', error);
        alert('❌ Error: ' + error.message);
    }
}

// Client-side removal for hard-coded favourites page
function removeCard(button) {
    try {
        const card = button.closest('.recipe-card');
        if (card) card.remove();
        // Notify user
        const main = document.querySelector('main');
        if (main) {
            const messageEl = document.createElement('div');
            messageEl.className = 'message success';
            messageEl.textContent = 'Removed from favorites (local)';
            main.insertBefore(messageEl, main.firstChild);
            setTimeout(() => messageEl.remove(), 4000);
        }
    } catch (e) {
        console.error('removeCard failed', e);
    }
}

// Initialize app based on page
let app;
document.addEventListener('DOMContentLoaded', () => {
    // Highlight active navigation link based on current pathname
    try {
        highlightActiveNav();
    } catch (e) {
        // ignore if highlight helper not available yet
    }
    const page = window.location.pathname.split('/').pop();
    
        if (page === 'recipe-details.html') {
            app = new RecipeDetails();
        } else {
            app = new MoodMeal();
        
            // Page-specific initializations
            if (page === 'index.html' || page === '') {
                // Load all recipes initially
                app.loadRecipes();
            }
        }
});

// Highlight the active nav link by comparing link href to current filename
function highlightActiveNav() {
    const current = window.location.pathname.split('/').pop() || 'index.html';
    // mark matching links
    document.querySelectorAll('nav .nav-links a').forEach(a => {
        const href = a.getAttribute('href') || '';
        const hrefFile = href.split('/').pop();
        if (hrefFile === current || (current === '' && hrefFile === 'index.html')) {
            a.classList.add('active');
            a.setAttribute('aria-current', 'page');
        } else {
            a.classList.remove('active');
            a.removeAttribute('aria-current');
        }
    });

    // also handle logo
    const logo = document.querySelector('.logo');
    if (logo) {
        const logoHref = (logo.getAttribute('href') || '').split('/').pop();
        if (logoHref === current || (current === '' && logoHref === 'index.html')) {
            logo.classList.add('active');
        } else {
            logo.classList.remove('active');
        }
    }
}
