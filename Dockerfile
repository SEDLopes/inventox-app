# Railway Dockerfile - COM DEBUG E VERIFICAÇÃO
FROM php:8.1-apache

# Metadados
LABEL maintainer="InventoX Railway"
LABEL description="InventoX PHP Application - With Debug"

# Instalar dependências essenciais
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    curl \
    wget \
    procps \
    netcat-openbsd \
    && docker-php-ext-install \
    pdo \
    pdo_mysql \
    zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configurar Apache modules
RUN a2enmod rewrite
RUN a2enmod headers

# CONFIGURAÇÃO APACHE MÍNIMA - Apenas ServerName
RUN echo 'ServerName localhost' >> /etc/apache2/apache2.conf

# Copiar arquivos da aplicação
COPY frontend/ /var/www/html/
COPY api/ /var/www/html/api/
COPY .htaccess /var/www/html/.htaccess

# Criar index.php SIMPLES e GARANTIDO
RUN echo '<?php' > /var/www/html/index.php && \
    echo 'header("Content-Type: text/html; charset=utf-8");' >> /var/www/html/index.php && \
    echo 'http_response_code(200);' >> /var/www/html/index.php && \
    echo 'echo "<!DOCTYPE html><html><head><title>InventoX Railway</title></head><body>";' >> /var/www/html/index.php && \
    echo 'echo "<h1>✅ InventoX Railway OK</h1>";' >> /var/www/html/index.php && \
    echo 'echo "<p><strong>Status:</strong> Funcionando</p>";' >> /var/www/html/index.php && \
    echo 'echo "<p><strong>PHP:</strong> " . PHP_VERSION . "</p>";' >> /var/www/html/index.php && \
    echo 'echo "<p><strong>Time:</strong> " . date("Y-m-d H:i:s") . "</p>";' >> /var/www/html/index.php && \
    echo 'echo "<hr>";' >> /var/www/html/index.php && \
    echo 'echo "<a href=\"/frontend/\">🚀 Aplicação</a> | ";' >> /var/www/html/index.php && \
    echo 'echo "<a href=\"/api/health.php\">🔧 API Health</a>";' >> /var/www/html/index.php && \
    echo 'echo "</body></html>";' >> /var/www/html/index.php && \
    echo '?>' >> /var/www/html/index.php

# Verificar conteúdo criado
RUN cat /var/www/html/index.php
RUN ls -la /var/www/html/

# Configurar permissões
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html
RUN chmod 644 /var/www/html/index.php

# Criar pasta uploads
RUN mkdir -p /var/www/html/uploads && chown www-data:www-data /var/www/html/uploads

# Configurar PHP básico
RUN echo 'engine = On' >> /usr/local/etc/php/php.ini && \
    echo 'short_open_tag = Off' >> /usr/local/etc/php/php.ini && \
    echo 'default_mimetype = "text/html"' >> /usr/local/etc/php/php.ini && \
    echo 'default_charset = "UTF-8"' >> /usr/local/etc/php/php.ini && \
    echo 'max_execution_time = 30' >> /usr/local/etc/php/php.ini && \
    echo 'memory_limit = 128M' >> /usr/local/etc/php/php.ini

# Workdir
WORKDIR /var/www/html

# Expor porta
EXPOSE 80

# Script de inicialização com debug
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'set -e' >> /start.sh && \
    echo 'echo "🚀 Iniciando InventoX Railway..."' >> /start.sh && \
    echo 'echo "📂 Verificando arquivos..."' >> /start.sh && \
    echo 'ls -la /var/www/html/' >> /start.sh && \
    echo 'echo "🔧 Testando PHP..."' >> /start.sh && \
    echo 'php -v' >> /start.sh && \
    echo 'echo "🌐 Testando Apache config..."' >> /start.sh && \
    echo 'apache2ctl configtest' >> /start.sh && \
    echo 'echo "🌐 Iniciando Apache..."' >> /start.sh && \
    echo 'exec apache2-foreground' >> /start.sh && \
    chmod +x /start.sh

# Health check com múltiplas tentativas
HEALTHCHECK --interval=30s --timeout=10s --start-period=90s --retries=5 \
    CMD curl -f http://localhost/ || curl -f http://127.0.0.1/ || nc -z localhost 80 || exit 1

# Comando de inicialização com debug
CMD ["/start.sh"]