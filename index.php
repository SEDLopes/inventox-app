<?php
// Ponto de entrada - Heroku buildpack usa /app como DocumentRoot
$request_uri = $_SERVER['REQUEST_URI'] ?? '';

// Se for API, processar diretamente
if (strpos($request_uri, '/api/') === 0) {
    // Deixar Apache processar normalmente
    return false;
}

// Redirecionar para frontend
if (file_exists(__DIR__ . '/frontend/index.html')) {
    header('Location: /frontend/index.html');
    exit;
}

// Mostrar info PHP
phpinfo();
?>
