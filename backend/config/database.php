<?php
// Helper function to return JSON responses
function jsonResponse($data, $status = 200) {
    http_response_code($status);
    header('Content-Type: application/json');
    header('Access-Control-Allow-Origin: *'); // For local development
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
    header('Access-Control-Allow-Headers: Content-Type');
    echo json_encode($data);
    exit;
}

// Database configuration
define('DB_HOST', 'localhost');
define('DB_PORT', '3306');        // XAMPP MySQL default port
define('DB_NAME', 'moodmeal');
define('DB_USER', 'root');        // Default XAMPP username
define('DB_PASS', '');            // Default XAMPP password (empty)

// Create PDO connection
try {
    $pdo = new PDO(
        "mysql:host=" . DB_HOST . ";port=" . DB_PORT . ";dbname=" . DB_NAME . ";charset=utf8mb4",
        DB_USER,
        DB_PASS,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false
        ]
    );
} catch (PDOException $e) {
    // Return JSON error so frontend can show a useful message
    jsonResponse(['error' => 'Database connection failed', 'details' => $e->getMessage()], 500);
}
// Note: Intentionally no closing PHP tag to avoid accidental output
