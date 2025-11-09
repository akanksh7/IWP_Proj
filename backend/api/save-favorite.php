<?php
// Favorites API: POST-only with action=list|add|remove
// Uses session user if logged in; otherwise falls back to demo user.

require_once '../config/database.php';

// Handle CORS preflight for local dev
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: POST, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type');
    http_response_code(204);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    jsonResponse(['error' => 'Method not allowed. Use POST with action=list|add|remove'], 405);
}

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

/**
 * Resolve a user id for favorites operations.
 * - If a user session exists, use it.
 * - Otherwise, fallback to the seeded demo user (create if missing).
 */
function resolveUserId(PDO $pdo): int {
    if (!empty($_SESSION['user_id'])) {
        return (int)$_SESSION['user_id'];
    }
    // Fallback: demo user (by email for uniqueness)
    $email = 'demo@moodmeal.com';
    $stmt = $pdo->prepare('SELECT id FROM users WHERE email = ? LIMIT 1');
    $stmt->execute([$email]);
    $row = $stmt->fetch();
    if ($row && isset($row['id'])) {
        return (int)$row['id'];
    }
    // Create demo user if not existing (password: "password")
    $username = 'demo_user';
    $hash = password_hash('password', PASSWORD_DEFAULT);
    $ins = $pdo->prepare('INSERT INTO users (username, email, password) VALUES (?, ?, ?)');
    $ins->execute([$username, $email, $hash]);
    return (int)$pdo->lastInsertId();
}

$action = isset($_POST['action']) ? strtolower(trim($_POST['action'])) : '';
if ($action === '') {
    jsonResponse(['error' => 'Missing action. Expected one of: list, add, remove'], 400);
}

try {
    $userId = resolveUserId($pdo);

    if ($action === 'list') {
        $sql = "SELECT r.*, m.name AS mood_name, m.color AS mood_color
                FROM favorites f
                JOIN recipes r ON f.recipe_id = r.id
                LEFT JOIN moods m ON r.mood_id = m.id
                WHERE f.user_id = ?
                ORDER BY f.created_at DESC";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$userId]);
        $rows = $stmt->fetchAll();

        // If no favorites yet and this is the demo user, seed a few defaults for a better demo experience
        if (empty($rows)) {
            $u = $pdo->prepare('SELECT username, email FROM users WHERE id = ? LIMIT 1');
            $u->execute([$userId]);
            $usr = $u->fetch();
            if ($usr && (isset($usr['email']) && $usr['email'] === 'demo@moodmeal.com' || isset($usr['username']) && $usr['username'] === 'demo_user')) {
                // Default recipe IDs to seed (adjust if your dataset differs)
                $defaultIds = [1, 2, 3, 4];
                $ins = $pdo->prepare('INSERT IGNORE INTO favorites (user_id, recipe_id) VALUES (?, ?)');
                foreach ($defaultIds as $rid) {
                    // Only insert if recipe exists
                    $chk = $pdo->prepare('SELECT id FROM recipes WHERE id = ?');
                    $chk->execute([$rid]);
                    if ($chk->fetch()) {
                        $ins->execute([$userId, $rid]);
                    }
                }
                // Re-query after seeding
                $stmt->execute([$userId]);
                $rows = $stmt->fetchAll();
            }
        }

        jsonResponse($rows);
    }

    if ($action === 'add') {
        $recipeId = (int)($_POST['recipe_id'] ?? 0);
        if ($recipeId <= 0) {
            jsonResponse(['error' => 'recipe_id is required'], 400);
        }

        // Ensure recipe exists
        $check = $pdo->prepare('SELECT id FROM recipes WHERE id = ?');
        $check->execute([$recipeId]);
        if (!$check->fetch()) {
            jsonResponse(['error' => 'Recipe not found'], 404);
        }

        $ins = $pdo->prepare('INSERT IGNORE INTO favorites (user_id, recipe_id) VALUES (?, ?)');
        $ins->execute([$userId, $recipeId]);
        if ($ins->rowCount() === 0) {
            jsonResponse(['success' => false, 'message' => 'Recipe already in favorites']);
        }
        jsonResponse(['success' => true, 'message' => 'Added to favorites!']);
    }

    if ($action === 'remove') {
        $recipeId = (int)($_POST['recipe_id'] ?? 0);
        if ($recipeId <= 0) {
            jsonResponse(['error' => 'recipe_id is required'], 400);
        }
        $del = $pdo->prepare('DELETE FROM favorites WHERE user_id = ? AND recipe_id = ?');
        $del->execute([$userId, $recipeId]);
        jsonResponse(['success' => true, 'message' => 'Removed from favorites!']);
    }

    jsonResponse(['error' => 'Unknown action. Use list|add|remove'], 400);
} catch (Throwable $e) {
    jsonResponse(['error' => 'Favorites error', 'details' => $e->getMessage()], 500);
}
