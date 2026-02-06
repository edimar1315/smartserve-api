# 🚀 SmartServe API - Quick Start Guide

## ⚡ Início Rápido (5 minutos)

### 1️⃣ Compile o Projeto
```bash
.\setup.bat
```
**O que faz:** Limpa, restaura, compila e cria migrations

### 2️⃣ Inicie os Serviços
```bash
.\start-containers.bat
```
**O que faz:** PostgreSQL, Redis, RabbitMQ, Adminer

### 3️⃣ Aplique as Migrations
```bash
cd SmartServe.Api
dotnet ef database update
```
**O que faz:** Cria as tabelas no banco de dados

### 4️⃣ Execute a API
```bash
dotnet run
```
**Acesse:** http://localhost:5000/swagger

---

## 📚 Documentação Completa

| Arquivo | Descrição |
|---------|-----------|
| **README.md** | Documentação técnica completa |
| **GETTING_STARTED.md** | Guia passo a passo detalhado |
| **SETUP_STATUS.md** | Status da configuração |
| **CHECKLIST.md** | Checklist completo |
| **SUMMARY.txt** | Sumário em texto puro |
| **INDEX.html** | Dashboard visual (abrir no navegador) |

---

## 🔐 Credenciais

```
PostgreSQL:  smartserve_user / smartserve_password_dev
RabbitMQ:    smartserve / smartserve_password_dev
Redis:       Sem autenticação
```

---

## 🌐 Links Úteis

- **API:** http://localhost:5000
- **Swagger:** http://localhost:5000/swagger
- **Adminer:** http://localhost:8080
- **RabbitMQ:** http://localhost:15672

---

## ⚡ Comandos Úteis

```bash
# Verificar status dos containers
docker-compose ps

# Ver logs do PostgreSQL
docker-compose logs postgres

# Parar tudo
.\stop-containers.bat

# Limpar banco de dados
docker-compose down -v
```

---

## ✅ Checklist

- [x] Projeto criado
- [x] Entidades definidas
- [x] Banco de dados configurado
- [x] Docker pronto
- [x] Documentação completa
- [ ] Executar setup.bat
- [ ] Iniciar containers
- [ ] Testar API

---

## 🎯 Próximo Passo

**Execute:** `.\setup.bat`

Divirta-se! 🎉

