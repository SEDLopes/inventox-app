<?php
// Redirecionar para index.html ou mostrar info PHP
if (file_exists('index.html')) {
    header('Location: index.html');
    exit;
} else {
    phpinfo();
}
?>
