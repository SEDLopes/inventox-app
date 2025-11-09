#!/bin/bash
# Script para iniciar aplicação InventoX

echo "🚀 InventoX - Iniciando Aplicação"
echo "=================================="
echo ""

# Verificar Docker
if ! docker info &>/dev/null; then
    echo "❌ Docker não está em execução"
    echo "Por favor, inicie Docker Desktop e tente novamente"
    exit 1
fi

echo "✅ Docker está em execução"
echo ""

# Limpar containers antigos
echo "🧹 Limpando containers antigos..."
docker-compose down --remove-orphans 2>/dev/null
docker ps -a | grep inventox | awk '{print $1}' | xargs -r docker rm -f 2>/dev/null

# Liberar portas
echo "🔓 Liberando portas..."
lsof -ti:8080 | xargs kill -9 2>/dev/null
lsof -ti:3307 | xargs kill -9 2>/dev/null

# Iniciar Docker Compose
echo "📦 Iniciando Docker Compose..."
docker-compose up -d --build

# Aguardar serviços iniciarem
echo "⏳ Aguardando serviços iniciarem (20 segundos)..."
sleep 20

# Verificar status
echo ""
echo "📊 Status dos serviços:"
docker-compose ps

# Verificar logs
echo ""
echo "📝 Últimas linhas dos logs:"
docker-compose logs web --tail=10 | grep -E "ready|started|error|Error" || echo "Aguardando logs..."

# Inicializar base de dados
echo ""
echo "📊 Inicializando base de dados..."
sleep 5
INIT_RESULT=$(curl -s "http://localhost:8080/api/init_database.php?token=inventox2024")
if echo "$INIT_RESULT" | grep -q "success"; then
    echo "✅ Base de dados inicializada com sucesso"
else
    echo "⚠️  Verificando se base de dados já existe..."
    echo "$INIT_RESULT" | head -5
fi

# Verificar saúde
echo ""
echo "🏥 Verificando saúde da aplicação..."
HEALTH=$(curl -s "http://localhost:8080/api/health.php")
if echo "$HEALTH" | grep -q "success"; then
    echo "✅ Aplicação está saudável"
else
    echo "⚠️  Aplicação ainda não está pronta"
    echo "$HEALTH" | head -5
fi

echo ""
echo "✅ Ambiente iniciado!"
echo ""
echo "🌐 Acesse: http://localhost:8080/frontend/"
echo "👤 Login: admin / admin123"
echo ""
echo "📝 Ver logs: docker-compose logs -f web"
echo "🛑 Parar: docker-compose down"

