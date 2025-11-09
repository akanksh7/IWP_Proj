<?php
// Add new recipe
require_once '../config/database.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    try {
        // Get POST data
        $title = $_POST['title'] ?? '';
        $description = $_POST['description'] ?? '';
        $ingredients = $_POST['ingredients'] ?? '';
        $instructions = $_POST['instructions'] ?? '';
        $prep_time = $_POST['prep_time'] ?? 0;
        $cook_time = $_POST['cook_time'] ?? 0;
        $servings = $_POST['servings'] ?? 1;
        $mood_id = $_POST['mood_id'] ?? null;
        $image_url = $_POST['image_url'] ?? '';
        
        // Basic validation
        if (empty($title) || empty($ingredients) || empty($instructions)) {
            jsonResponse(['error' => 'Title, ingredients, and instructions are required'], 400);
        }
        
        // Insert recipe
        $stmt = $pdo->prepare("
            INSERT INTO recipes (title, description, ingredients, instructions, prep_time, cook_time, servings, mood_id, image_url) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ");
        
        $stmt->execute([
            $title, $description, $ingredients, $instructions, 
            $prep_time, $cook_time, $servings, $mood_id, $image_url
        ]);
        
        $recipe_id = $pdo->lastInsertId();
        
        jsonResponse([
            'success' => true,
            'message' => 'Recipe added successfully!',
            'recipe_id' => $recipe_id
        ]);
        
    } catch (Exception $e) {
        jsonResponse(['error' => 'Failed to add recipe: ' . $e->getMessage()], 500);
    }
}
?>
