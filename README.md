# 🍽️ MoodMeal - Mood-Based Recipe Recommendation Platform

**Internet and Web Programming Project**  
*A sophisticated web application that recommends recipes based on your current mood*

---

## 🎯 **Project Overview**

MoodMeal is a dynamic recipe recommendation platform that connects your emotions with delicious food choices. Users can discover recipes tailored to their current mood, view detailed cooking instructions, save favorites, and contribute their own recipes to the community.

---

## ✨ **Key Features**

### 🎭 **Mood-Based Recipe Discovery**
- **6 Mood Categories**: Happy, Sad, Energetic, Relaxed, Romantic, Stressed
- **42+ Curated Recipes**: 7 recipes per mood category with detailed instructions
- **Smart Filtering**: Instantly filter recipes based on selected mood

### 👤 **User Authentication System**
- **Secure Registration & Login**: Password hashing with bcrypt
- **Session Management**: Persistent user sessions across pages
- **Demo Account**: `demo_user` / `password123` for testing

### 📖 **Recipe Management**
- **Detailed Recipe Pages**: Ingredients, instructions, prep/cook time, servings
- **Add New Recipes**: Users can contribute their own mood-tagged recipes
- **Search Functionality**: Find recipes by title or ingredients
- **Favorites System**: Save and manage favorite recipes

### 🎨 **Modern UI/UX**
- **Responsive Design**: Works seamlessly on desktop, tablet, and mobile
- **Color-Coded Moods**: Each mood has distinctive colors for easy navigation
- **Interactive Cards**: Hover effects and smooth transitions
- **Clean Navigation**: Intuitive user interface with clear call-to-actions

---

## 🛠️ **Technology Stack**

### **Frontend Technologies**
- **HTML5**: Semantic markup with accessibility features
- **CSS3**: Flexbox/Grid layouts, responsive design, custom animations
- **JavaScript ES6+**: Classes, async/await, fetch API, DOM manipulation

### **Backend Technologies**
- **PHP 7+**: Object-oriented programming, PDO database connections
- **Session Management**: Secure user authentication and state management
- **RESTful APIs**: JSON-based communication between frontend and backend

### **Database**
- **MySQL**: Relational database with proper foreign key relationships
- **Structured Schema**: Users, moods, recipes, and favorites tables
- **Sample Data**: 42 realistic recipes with detailed cooking information

### **Server Environment**
- **XAMPP**: Apache web server and MySQL database
- **Local Development**: Configured for localhost with default port (3306)

---

## 📁 **Project Structure**

```
IAWPProj/
├── frontend/                 # Client-side application
│   ├── index.html           # Homepage with mood selection
│   ├── recipe-details.html  # Individual recipe view
│   ├── add-recipe.html      # Recipe submission form
│   ├── favourites.html      # User's saved recipes
│   ├── search.html          # Recipe search functionality
│   ├── login.html           # User authentication
│   ├── css/
│   │   └── style.css        # Complete styling and responsive design
│   └── js/
│       ├── main.js          # Core application logic (MoodMeal class)
│       └── auth.js          # Authentication management (AuthManager class)
│
├── backend/                 # Server-side application
│   ├── api/                 # RESTful API endpoints
│   │   ├── get-recipes.php  # Recipe data retrieval
│   │   ├── add-recipe.php   # Recipe submission handling
│   │   ├── save-favorite.php # Favorites management
│   │   └── user-auth.php    # Login/registration processing
│   ├── config/
│   │   └── database.php     # PDO database connection
│   └── database/
│       └── setup.sql        # Complete database schema and sample data
│
└── README.md               # Project documentation
```

---

## 🚀 **Setup Instructions**

### **Prerequisites**
- XAMPP or WAMP server installed
- Web browser (Chrome, Firefox, Safari)
- Basic understanding of localhost setup

### **Installation Steps**

1. **📥 Download & Extract**
   ```
   Extract IAWPProj folder to C:\xampp\htdocs\
   ```

2. **🗄️ Database Setup**
   - Start XAMPP (Apache + MySQL)
   - Open phpMyAdmin: `http://localhost/phpmyadmin`
   - Import `backend/database/setup.sql`
   - Verify 42 recipes are loaded across 6 moods

3. **🌐 Access Application**
   ```
   Homepage: http://localhost/IAWPProj/frontend/
   Demo Login: demo_user / password123
   ```

### **Port Configuration**
- **Apache**: Port 80 (default)
- **MySQL**: Port 3306 (default)

---

## 🎮 **How to Use**

### **1. Browse by Mood**
- Visit homepage and select your current mood
- Browse 7+ recipes curated for that emotional state
- Click "View Recipe" to see detailed cooking instructions

### **2. User Authentication**
- Register new account or use demo credentials
- Login persists across browser sessions
- Access personalized features after authentication

### **3. Recipe Management**
- Add your own recipes with mood tags
- Search existing recipes by title or ingredients
- Save favorites for quick access

### **4. Detailed Recipe View**
- Complete ingredient lists with measurements
- Step-by-step cooking instructions
- Prep time, cook time, and serving information
- Mood association and color coding

---

## 💡 **Key Learning Outcomes**

### **Web Development Concepts**
- **Client-Server Architecture**: Clear separation of frontend/backend concerns
- **Database Design**: Normalized schema with proper relationships
- **API Development**: RESTful endpoints with JSON responses
- **Security**: Password hashing, session management, input validation

### **Programming Skills**
- **JavaScript Classes**: Object-oriented frontend architecture
- **PHP PDO**: Secure database interactions with prepared statements
- **CSS Grid/Flexbox**: Modern layout techniques for responsive design
- **AJAX Communication**: Asynchronous data fetching without page reloads

### **Project Management**
- **File Organization**: Logical folder structure for maintainability
- **Version Control Ready**: Clean codebase suitable for Git
- **Documentation**: Comprehensive README for knowledge transfer

---

## 🔮 **Future Enhancements**

- **Recipe Ratings & Reviews**: Community feedback system
- **Advanced Search**: Filter by dietary restrictions, cook time, ingredients
- **Social Features**: Share recipes on social media platforms
- **Meal Planning**: Weekly meal plans based on mood patterns
- **Mobile App**: React Native or Flutter mobile application
- **AI Integration**: Machine learning for personalized recommendations

---

## 👨‍💻 **Technical Highlights**

### **Database Schema**
- 4 interconnected tables with foreign key relationships
- Unique constraints to prevent duplicate favorites
- Timestamps for audit trails and sorting

### **Security Features**
- Bcrypt password hashing (cost factor 10)
- PDO prepared statements prevent SQL injection
- Session-based authentication with fallback handling
- CORS headers for secure API communication

### **Performance Optimizations**
- Efficient SQL queries with JOINs for related data
- Minimal HTTP requests through strategic API design
- CSS/JS file organization for fast loading
- Responsive images and optimized assets

---

## 📊 **Project Statistics**

- **📄 6 HTML Pages**: Complete user journey from discovery to recipe viewing
- **🎨 1 Comprehensive CSS File**: 500+ lines of responsive styling
- **⚡ 2 JavaScript Classes**: Modular, object-oriented frontend architecture
- **🔧 4 PHP APIs**: RESTful backend services with error handling
- **🍽️ 42 Recipes**: Realistic, detailed recipes across 6 mood categories
- **🗃️ 4 Database Tables**: Properly normalized schema with relationships

---

## 🎯 **Presentation Demo Flow**

### **Live Demo Sequence**
1. **Homepage Tour** - Show mood selection and recipe cards
2. **Recipe Details** - Demonstrate detailed recipe view
3. **User Registration** - Create new account
4. **Add Recipe** - Submit a new recipe
5. **Search Function** - Find specific recipes
6. **Login System** - Show persistent sessions

### **Code Highlights to Discuss**
- JavaScript classes and modern ES6+ features
- PHP PDO security with prepared statements
- CSS Grid/Flexbox responsive design
- Database normalization and relationships

---

**Developed for Internet and Web Programming Course**  
*Demonstrating full-stack web development skills with modern technologies*
