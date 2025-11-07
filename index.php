<?php
// Redirecionar para frontend ou servir API
$request_uri = $_SERVER['REQUEST_URI'] ?? '';

// Se for uma requisição para API, não redirecionar
if (strpos($request_uri, '/api/') === 0) {
    // Deixar o Apache processar normalmente
    return false;
}

// Redirecionar para frontend
if (file_exists(__DIR__ . '/frontend/index.html')) {
    header('Location: /frontend/index.html');
    exit;
}

// Se não existir frontend, mostrar info PHP
phpinfo();
?>
