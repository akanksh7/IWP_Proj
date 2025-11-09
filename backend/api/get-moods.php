<?php
// Get all available moods
require_once '../config/database.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    try {
        $stmt = $pdo->prepare("SELECT * FROM moods ORDER BY name");
        $stmt->execute();
        $moods = $stmt->fetchAll();
        
        jsonResponse($moods);
        
    } catch (Exception $e) {
        jsonResponse(['error' => 'Failed to fetch moods'], 500);
    }
}
?>
