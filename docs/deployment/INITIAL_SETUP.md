# 🚀 Setup Inicial - InventoX no DigitalOcean

Guia para configurar o InventoX após o deploy bem-sucedido.

## ✅ Deploy Bem-Sucedido!

Se você está vendo a página inicial com:
- ✅ InventoX OK
- ✅ Status: Funcionando
- ✅ PHP: 8.1.33

Parabéns! O deploy foi bem-sucedido! 🎉

## 📋 Passos de Configuração

### 1. Verificar API Health

Acesse o endpoint de health check:
```
https://seu-app.ondigitalocean.app/api/health.php
```

**Resultado esperado:**
```json
{
  "status": "healthy",
  "timestamp": "2025-11-08 13:10:31",
  "php_version": "8.1.33",
  "services": {
    "database": "not_configured" ou "connected",
    "uploads": "ready" ou "not_ready"
  }
}
```

### 2. Inicializar Database

Acesse o endpoint de inicialização:
```
https://seu-app.ondigitalocean.app/api/init_database.php?token=inventox2024
```

**O que este endpoint faz:**
- ✅ Cria todas as tabelas necessárias
- ✅ Insere dados iniciais (usuário admin, categorias, etc.)
- ✅ Configura estrutura completa

**Resultado esperado:**
```json
{
  "success": true,
  "message": "Database inicializado com sucesso!",
  "tables_created": 8,
  "initial_data": true
}
```

### 3. Verificar Database

Após inicializar, verifique novamente o health check:
```
https://seu-app.ondigitalocean.app/api/health.php
```

Agora deve mostrar:
```json
{
  "status": "healthy",
  "services": {
    "database": "connected"  // ✅ Conectado!
  }
}
```

### 4. Acessar Aplicação

Acesse a aplicação completa:
```
https://seu-app.ondigitalocean.app/frontend/
```

**Credenciais padrão:**
- **Usuário:** admin
- **Senha:** admin123

⚠️ **IMPORTANTE:** Altere a senha após o primeiro login!

## 🔧 Troubleshooting

### API Health retorna erro

- Verifique se o Apache está rodando
- Verifique os logs no DigitalOcean Dashboard
- Teste o endpoint `/api/health.php`

### Database não inicializa

- Verifique as variáveis de ambiente no DigitalOcean
- Certifique-se que o database está rodando
- Verifique os logs do endpoint `/api/init_database.php`

### Aplicação não carrega

- Verifique se o frontend está acessível
- Teste o endpoint `/frontend/`
- Verifique os logs do container

## ✅ Checklist Final

- [ ] API Health funcionando
- [ ] Database inicializado
- [ ] Database conectado (verificado no health check)
- [ ] Aplicação acessível (`/frontend/`)
- [ ] Login funcionando
- [ ] Senha admin alterada

## 🎉 Pronto!

Após completar estes passos, sua aplicação estará 100% funcional!

Para atualizações futuras, basta fazer `git push` para o repositório GitHub e o DigitalOcean fará deploy automático.
