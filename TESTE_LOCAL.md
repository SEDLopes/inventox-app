# 🧪 Guia de Teste Local - InventoX

**Data:** 2024-11-09  
**Objetivo:** Testar e corrigir o aplicativo localmente antes de fazer deploy

---

## 📋 Pré-requisitos

1. **Docker e Docker Compose** instalados
2. **MySQL** (ou usar Docker)
3. **PHP 8.1+** (ou usar Docker)

---

## 🚀 Configuração Inicial

### 1. Criar ficheiro `.env`

```bash
cp .env.example .env
```

Editar `.env` com as configurações locais:

```env
DB_HOST=localhost
DB_NAME=inventox
DB_USER=inventox
DB_PASS=inventox123
DB_PORT=3306
DEBUG_MODE=true
ENVIRONMENT=development
```

### 2. Iniciar Docker Compose

```bash
docker-compose up -d
```

Isso irá:
- ✅ Iniciar MySQL na porta 3306
- ✅ Iniciar Apache/PHP na porta 80
- ✅ Criar volumes para dados persistentes

### 3. Inicializar Base de Dados

Acessar:
```
http://localhost/api/init_database.php?token=inventox2024
```

Ou executar manualmente:
```bash
mysql -u inventox -pinventox123 inventox < db.sql
```

---

## 🧪 Testes a Realizar

### 1. **Teste de Login** ✅
- [ ] Acessar `http://localhost/frontend/`
- [ ] Fazer login com `admin` / `admin123`
- [ ] Verificar se a sessão é mantida
- [ ] Verificar se cookies são enviados

### 2. **Teste de Criação de Empresa** ✅
- [ ] Criar uma nova empresa
- [ ] Verificar se é salva na base de dados
- [ ] Verificar se aparece na lista

### 3. **Teste de Criação de Armazém** ✅
- [ ] Criar um novo armazém
- [ ] Associar a uma empresa
- [ ] Verificar se é salvo corretamente

### 4. **Teste de Criação de Artigo** ✅
- [ ] Criar um novo artigo
- [ ] Verificar se é salvo na base de dados
- [ ] Verificar se aparece na lista

### 5. **Teste de Criação de Sessão** ✅
- [ ] Criar uma nova sessão de inventário
- [ ] Associar a empresa e armazém
- [ ] Verificar se é salva corretamente

### 6. **Teste de Criação de Utilizador** ✅
- [ ] Criar um novo utilizador
- [ ] Verificar se é salvo na base de dados
- [ ] Verificar se pode fazer login

---

## 🔍 Verificações de Erros

### Erros Comuns e Soluções

#### 1. **Erro 401 (Unauthorized)**
**Causa:** Sessão não está sendo mantida  
**Solução:**
- Verificar se cookies estão sendo enviados
- Verificar configuração de sessão em `api/db.php`
- Verificar se `credentials: 'include'` está presente no frontend

#### 2. **Erro 500 (Internal Server Error)**
**Causa:** Tabelas não existem ou colunas faltantes  
**Solução:**
- Executar `init_database.php` ou `migrate_database.php`
- Verificar logs do servidor: `docker-compose logs web`

#### 3. **Erro de Conexão com Base de Dados**
**Causa:** Configuração incorreta do `.env`  
**Solução:**
- Verificar se `.env` existe e tem valores corretos
- Verificar se MySQL está em execução: `docker-compose ps`
- Testar conexão: `mysql -u inventox -pinventox123 inventox`

---

## 📊 Logs e Debug

### Ver Logs do Servidor

```bash
# Logs do Apache/PHP
docker-compose logs web

# Logs do MySQL
docker-compose logs db

# Logs em tempo real
docker-compose logs -f web
```

### Verificar Base de Dados

```bash
# Conectar ao MySQL
docker-compose exec db mysql -u inventox -pinventox123 inventox

# Verificar tabelas
SHOW TABLES;

# Verificar estrutura de uma tabela
DESCRIBE users;
DESCRIBE companies;
DESCRIBE warehouses;
DESCRIBE items;
DESCRIBE inventory_sessions;
```

---

## ✅ Checklist de Funcionalidades

### Funcionalidades Principais
- [ ] Login funciona corretamente
- [ ] Sessão é mantida entre requisições
- [ ] Criar empresa funciona
- [ ] Criar armazém funciona
- [ ] Criar artigo funciona
- [ ] Criar sessão funciona
- [ ] Criar utilizador funciona
- [ ] Listar registos funciona
- [ ] Editar registos funciona
- [ ] Eliminar registos funciona

### Funcionalidades Secundárias
- [ ] Importar artigos (CSV/XLSX) funciona
- [ ] Exportar sessões funciona
- [ ] Estatísticas funcionam
- [ ] Histórico de movimentações funciona
- [ ] Scanner de código de barras funciona

---

## 🐛 Problemas Conhecidos

### 1. **Sessão não mantida após login**
**Status:** 🔴 Em investigação  
**Sintomas:** Login funciona, mas próximas requisições retornam 401  
**Possíveis causas:**
- Cookies não estão sendo enviados
- Configuração de sessão incorreta
- Problema com SameSite cookie attribute

### 2. **Tabelas não existem**
**Status:** ✅ Corrigido (verificação adicionada)  
**Solução:** Executar `init_database.php` ou `migrate_database.php`

### 3. **Colunas faltantes**
**Status:** ✅ Corrigido (verificação dinâmica adicionada)  
**Solução:** Executar `migrate_database.php`

---

## 📝 Notas

- **Desenvolvimento Local:** Use `DEBUG_MODE=true` no `.env`
- **Produção:** Use `DEBUG_MODE=false` no `.env`
- **Sessões:** Verificar se diretório de sessões tem permissões corretas
- **Uploads:** Verificar se diretório `uploads/` tem permissões de escrita

---

**Última Atualização:** 2024-11-09

