#!/bin/bash
# Script para iniciar ambiente local do InventoX

echo "🚀 InventoX - Iniciando Ambiente Local"
echo "======================================"
echo ""

# Verificar se Docker está disponível
if command -v docker &> /dev/null && docker info &> /dev/null; then
    echo "✅ Docker encontrado e em execução"
    echo ""
    echo "📦 Iniciando Docker Compose..."
    docker-compose up -d
    
    echo ""
    echo "⏳ Aguardando serviços iniciarem (15 segundos)..."
    sleep 15
    
    echo ""
    echo "🔍 Verificando serviços..."
    docker-compose ps
    
    echo ""
    echo "📊 Inicializando base de dados..."
    sleep 5
    curl -s "http://localhost/api/init_database.php?token=inventox2024" | head -10
    
    echo ""
    echo "✅ Ambiente iniciado!"
    echo ""
    echo "🌐 Acesse: http://localhost/frontend/"
    echo "👤 Login: admin / admin123"
    echo ""
    echo "📝 Ver logs: docker-compose logs -f web"
    
else
    echo "⚠️  Docker não está disponível"
    echo ""
    echo "📋 Opções:"
    echo "1. Iniciar Docker Desktop e executar este script novamente"
    echo "2. Usar setup sem Docker (ver SETUP_SEM_DOCKER.md)"
    echo ""
    
    # Verificar se PHP está disponível
    if command -v php &> /dev/null; then
        echo "✅ PHP encontrado: $(php -v | head -1)"
        echo ""
        echo "🚀 Iniciando servidor PHP..."
        echo "Acesse: http://localhost:8080/frontend/"
        echo ""
        php -S localhost:8080 -t .
    else
        echo "❌ PHP não encontrado"
        echo "Por favor, instale PHP 8.1+ ou inicie Docker Desktop"
    fi
fi

