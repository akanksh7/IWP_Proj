// Authentication utilities for all pages
class AuthManager {
    constructor() {
        this.currentUser = null;
        this.checkAuthStatus();
    }

    async checkAuthStatus() {
        try {
            const response = await fetch('../backend/api/user-auth.php?action=check');
            const data = await response.json();
            
            if (data.logged_in) {
                this.currentUser = data.user;
                this.updateUI(true);
            } else {
                this.currentUser = null;
                this.updateUI(false);
            }
        } catch (error) {
            console.log('Auth check failed');
            this.currentUser = null;
            this.updateUI(false);
        }
    }

    updateUI(isLoggedIn) {
        // Update navigation based on login status
        const loginLink = document.querySelector('a[href="login.html"]');
        if (loginLink) {
            if (isLoggedIn) {
                loginLink.textContent = `👤 ${this.currentUser.username}`;
                loginLink.href = 'login.html';
            } else {
                loginLink.textContent = 'Login';
                loginLink.href = 'login.html';
            }
        }
    }

    getCurrentUserId() {
        return this.currentUser ? this.currentUser.id : 1; // Default to user 1 if not logged in
    }

    isLoggedIn() {
        return this.currentUser !== null;
    }
}

// Create global auth manager
const authManager = new AuthManager();
