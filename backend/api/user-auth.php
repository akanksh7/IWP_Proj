<?php
// Simple authentication system
require_once '../config/database.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $action = $_POST['action'] ?? '';
    
    if ($action === 'login') {
        // Handle login
        $email = $_POST['email'] ?? '';
        $password = $_POST['password'] ?? '';
        
        if (empty($email) || empty($password)) {
            jsonResponse(['error' => 'Email and password are required'], 400);
        }
        
        try {
            $stmt = $pdo->prepare("SELECT id, username, email, password FROM users WHERE email = ?");
            $stmt->execute([$email]);
            $user = $stmt->fetch();
            
            if ($user && password_verify($password, $user['password'])) {
                // Start session and store user info
                session_start();
                $_SESSION['user_id'] = $user['id'];
                $_SESSION['username'] = $user['username'];
                $_SESSION['email'] = $user['email'];
                
                jsonResponse([
                    'success' => true,
                    'message' => 'Login successful!',
                    'user' => [
                        'id' => $user['id'],
                        'username' => $user['username'],
                        'email' => $user['email']
                    ]
                ]);
            } else {
                jsonResponse(['error' => 'Invalid email or password'], 401);
            }
        } catch (Exception $e) {
            jsonResponse(['error' => 'Login failed'], 500);
        }
        
    } elseif ($action === 'register') {
        // Handle registration
        $username = $_POST['username'] ?? '';
        $email = $_POST['email'] ?? '';
        $password = $_POST['password'] ?? '';
        
        if (empty($username) || empty($email) || empty($password)) {
            jsonResponse(['error' => 'All fields are required'], 400);
        }
        
        try {
            // Check if user already exists
            $stmt = $pdo->prepare("SELECT id FROM users WHERE email = ? OR username = ?");
            $stmt->execute([$email, $username]);
            
            if ($stmt->fetch()) {
                jsonResponse(['error' => 'User already exists with this email or username'], 400);
            }
            
            // Create new user
            $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
            $stmt = $pdo->prepare("INSERT INTO users (username, email, password) VALUES (?, ?, ?)");
            $stmt->execute([$username, $email, $hashedPassword]);
            
            $userId = $pdo->lastInsertId();
            
            // Start session
            session_start();
            $_SESSION['user_id'] = $userId;
            $_SESSION['username'] = $username;
            $_SESSION['email'] = $email;
            
            jsonResponse([
                'success' => true,
                'message' => 'Account created successfully!',
                'user' => [
                    'id' => $userId,
                    'username' => $username,
                    'email' => $email
                ]
            ]);
            
        } catch (Exception $e) {
            jsonResponse(['error' => 'Registration failed'], 500);
        }
    }
    
} elseif ($method === 'GET') {
    $action = $_GET['action'] ?? '';
    
    if ($action === 'check') {
        // Check if user is logged in
        session_start();
        
        if (isset($_SESSION['user_id'])) {
            jsonResponse([
                'logged_in' => true,
                'user' => [
                    'id' => $_SESSION['user_id'],
                    'username' => $_SESSION['username'],
                    'email' => $_SESSION['email']
                ]
            ]);
        } else {
            jsonResponse(['logged_in' => false]);
        }
        
    } elseif ($action === 'logout') {
        // Logout user
        session_start();
        session_destroy();
        jsonResponse(['success' => true, 'message' => 'Logged out successfully']);
    }
}
?>
