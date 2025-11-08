<?php
// Railway entry point - HEALTHCHECK FRIENDLY
$request_uri = $_SERVER['REQUEST_URI'] ?? '';

// Health check - responder OK
if ($request_uri === '/' || $request_uri === '/health') {
    http_response_code(200);
    header('Content-Type: text/html; charset=utf-8');
    echo "<!DOCTYPE html>
<html>
<head>
    <title>InventoX - Railway</title>
    <meta charset='utf-8'>
</head>
<body>
    <h1>✅ InventoX no Railway</h1>
    <p><strong>Status:</strong> Funcionando</p>
    <p><a href='/frontend/index.html'>🚀 Aceder à aplicação</a></p>
    <p><a href='/api/health.php'>🔧 Health Check API</a></p>
    <hr>
    <small>PHP " . PHP_VERSION . " | Apache | " . date('Y-m-d H:i:s') . "</small>
</body>
</html>";
    exit;
}

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

// Fallback
http_response_code(200);
echo "InventoX - Railway OK";
?>