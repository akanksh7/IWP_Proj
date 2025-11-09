<?php
// Get recipes based on mood or all recipes
require_once '../config/database.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    try {
        // Check if we're getting a single recipe by ID
        if (isset($_GET['id'])) {
            $id = $_GET['id'];
            $stmt = $pdo->prepare("
                SELECT r.*, m.name as mood_name, m.color as mood_color 
                FROM recipes r 
                LEFT JOIN moods m ON r.mood_id = m.id 
                WHERE r.id = ?
            ");
            $stmt->execute([$id]);
            $recipe = $stmt->fetch();
            
            if ($recipe) {
                jsonResponse($recipe);
            } else {
                jsonResponse(['error' => 'Recipe not found'], 404);
            }
            return;
        }
        
        // Get recipes by mood or all recipes
        $mood_id = $_GET['mood_id'] ?? null;
        
        if ($mood_id) {
            // Get recipes for specific mood
            $stmt = $pdo->prepare("
                SELECT r.*, m.name as mood_name, m.color as mood_color 
                FROM recipes r 
                JOIN moods m ON r.mood_id = m.id 
                WHERE r.mood_id = ? 
                ORDER BY r.created_at DESC
            ");
            $stmt->execute([$mood_id]);
        } else {
            // Get all recipes
            $stmt = $pdo->prepare("
                SELECT r.*, m.name as mood_name, m.color as mood_color 
                FROM recipes r 
                LEFT JOIN moods m ON r.mood_id = m.id 
                ORDER BY r.created_at DESC
            ");
            $stmt->execute();
        }
        
        $recipes = $stmt->fetchAll();
        jsonResponse($recipes);
        
    } catch (Exception $e) {
        jsonResponse(['error' => 'Failed to fetch recipes: ' . $e->getMessage()], 500);
    }
}
?>
