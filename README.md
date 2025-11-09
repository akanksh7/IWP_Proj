 # MoodMeal

 A simple mood-based recipe web application built for local development with XAMPP. Users can register, log in, browse recipes by mood, view recipe details, add recipes, and save favorites.

 ## Quick summary
 - Frontend: HTML, CSS, JavaScript (vanilla)
 - Backend: PHP APIs using PDO
 - Database: MySQL (schema in `backend/database/setup.sql`)
 - Server: XAMPP (Apache + MySQL)

 ## How to run locally
 1. Copy the project folder to `C:\xampp\htdocs\IAWPProj`
 2. Start Apache and MySQL from the XAMPP control panel
 3. Open phpMyAdmin at `http://localhost/phpmyadmin` and import `backend/database/setup.sql`
 4. Open the app at `http://localhost/IAWPProj/frontend/`

 ## Main files
 - `frontend/` — HTML pages, `css/style.css`, `js/main.js`, `js/auth.js`
 - `backend/api/` — PHP endpoints (`user-auth.php`, `get-recipes.php`, `add-recipe.php`, `save-favorite.php`, etc.)
 - `backend/config/database.php` — PDO connection and json response helper

 ## Features
 - User registration and login (session-based)
 - Browse recipes by mood, view details, add recipes
 - Search recipes and save favorites

 ## Notes
 - Test account: demo user can be created by registering or via seed data if provided in `setup.sql`.
 - Always open the site via `http://localhost/...` (not the file system) so API calls and sessions work.

 --

 Developed for an Internet and Web Programming course.
