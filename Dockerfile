# Railway Dockerfile - CORRIGIR HEALTHCHECK
FROM php:8.1-apache

# Metadados
LABEL maintainer="InventoX"
LABEL description="InventoX PHP Application for Railway"

# Instalar extensões PHP necessárias
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    curl \
    && docker-php-ext-install \
    pdo \
    pdo_mysql \
    zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configurar Apache
RUN a2enmod rewrite
RUN a2enmod headers

# CONFIGURAÇÃO APACHE SIMPLIFICADA PARA RAILWAY
RUN echo 'ServerName localhost' >> /etc/apache2/apache2.conf
RUN echo 'Listen 80' >> /etc/apache2/apache2.conf

# Configurar DocumentRoot
RUN echo 'DocumentRoot /var/www/html' >> /etc/apache2/apache2.conf
RUN echo '<Directory /var/www/html>' >> /etc/apache2/apache2.conf
RUN echo '    Options Indexes FollowSymLinks' >> /etc/apache2/apache2.conf
RUN echo '    AllowOverride All' >> /etc/apache2/apache2.conf
RUN echo '    Require all granted' >> /etc/apache2/apache2.conf
RUN echo '    DirectoryIndex index.html index.php' >> /etc/apache2/apache2.conf
RUN echo '</Directory>' >> /etc/apache2/apache2.conf

# Copiar arquivos da aplicação
COPY frontend/ /var/www/html/
COPY api/ /var/www/html/api/
COPY .htaccess /var/www/html/.htaccess
COPY index.php /var/www/html/index.php

# Verificar arquivos copiados
RUN ls -la /var/www/html/ | head -10
RUN ls -la /var/www/html/api/ | head -5

# Configurar permissões
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Criar pasta de uploads
RUN mkdir -p /var/www/html/uploads && chown www-data:www-data /var/www/html/uploads

# Configurar PHP básico
RUN echo 'engine = On' >> /usr/local/etc/php/php.ini
RUN echo 'short_open_tag = Off' >> /usr/local/etc/php/php.ini
RUN echo 'default_mimetype = "text/html"' >> /usr/local/etc/php/php.ini
RUN echo 'default_charset = "UTF-8"' >> /usr/local/etc/php/php.ini

# Workdir
WORKDIR /var/www/html

# Expor porta 80
EXPOSE 80

# Health check simples
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Comando para iniciar Apache
CMD ["apache2-foreground"]