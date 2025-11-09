<?php
// Search recipes by title or ingredients
require_once '../config/database.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    try {
        $query = $_GET['q'] ?? '';
        
        if (empty($query)) {
            // Return all recipes if no search query
            $stmt = $pdo->prepare("
                SELECT r.*, m.name as mood_name, m.color as mood_color 
                FROM recipes r 
                LEFT JOIN moods m ON r.mood_id = m.id 
                ORDER BY r.created_at DESC
            ");
            $stmt->execute();
        } else {
            // Search in title, description, and ingredients
            $searchTerm = '%' . $query . '%';
            $stmt = $pdo->prepare("
                SELECT r.*, m.name as mood_name, m.color as mood_color 
                FROM recipes r 
                LEFT JOIN moods m ON r.mood_id = m.id 
                WHERE r.title LIKE ? 
                    OR r.description LIKE ? 
                    OR r.ingredients LIKE ? 
                ORDER BY 
                    CASE 
                        WHEN r.title LIKE ? THEN 1
                        WHEN r.description LIKE ? THEN 2
                        ELSE 3
                    END, 
                    r.created_at DESC
            ");
            $stmt->execute([$searchTerm, $searchTerm, $searchTerm, $searchTerm, $searchTerm]);
        }
        
        $recipes = $stmt->fetchAll();
        jsonResponse($recipes);
        
    } catch (Exception $e) {
        jsonResponse(['error' => 'Search failed'], 500);
    }
}
?>
