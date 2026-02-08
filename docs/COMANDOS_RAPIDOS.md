# Comandos Rápidos - SmartServe API

## 🚀 Setup Inicial (Execute Uma Vez)

```powershell
# 1. Abrir Docker Desktop (aguardar inicializar)

# 2. Executar correção automática
cd C:\Users\edima\OneDrive\smartserve\smartserve-api
.\fix-setup.bat

# OU (PowerShell robusto)
powershell -ExecutionPolicy Bypass -File .\fix-setup.ps1
```

---

## 📦 Docker

```powershell
# Verificar Docker rodando
docker info

# Subir todos os containers
docker-compose up -d

# Ver status dos containers
docker-compose ps

# Ver logs
docker-compose logs
docker-compose logs postgres
docker-compose logs redis

# Parar containers
docker-compose stop

# Parar e remover containers
docker-compose down

# Recriar containers do zero
docker-compose down -v
docker-compose up -d
```

---

## 🗃️ Banco de Dados / Migrations

```powershell
# Navegar para pasta da API
cd C:\Users\edima\OneDrive\smartserve\smartserve-api\SmartServe.Api

# Criar nova migration
dotnet ef migrations add NomeDaMigration

# Aplicar migrations
dotnet ef database update

# Reverter última migration
dotnet ef migrations remove

# Ver migrations aplicadas
dotnet ef migrations list

# Gerar script SQL da migration
dotnet ef migrations script

# Resetar banco (CUIDADO: apaga tudo)
dotnet ef database drop
dotnet ef database update
```

---

## 🏃 Executar API

```powershell
# Restaurar dependências
dotnet restore

# Compilar
dotnet build

# Executar em modo desenvolvimento
cd C:\Users\edima\OneDrive\smartserve\smartserve-api\SmartServe.Api
dotnet run

# Executar com watch (recarrega ao salvar)
dotnet watch run

# Executar em produção
dotnet run --configuration Release
```

**Endpoints após iniciar:**
- Swagger: http://localhost:5000/swagger
- Health: http://localhost:5000/api/health
- API Base: http://localhost:5000/api

---

## 🧪 Testes

```powershell
# Executar todos os testes
dotnet test

# Executar com cobertura
dotnet test --collect:"XPlat Code Coverage"

# Executar testes específicos
dotnet test --filter "FullyQualifiedName~ServiceTests"
```

---

## 🔧 Troubleshooting

```powershell
# Limpar build
dotnet clean

# Restaurar com limpeza de cache
dotnet nuget locals all --clear
dotnet restore

# Ver versão do .NET
dotnet --version

# Ver SDKs instalados
dotnet --list-sdks

# Ver runtimes instalados
dotnet --list-runtimes

# Verificar EF Tools
dotnet ef --version

# Instalar/atualizar EF Tools
dotnet tool install --global dotnet-ef
dotnet tool update --global dotnet-ef
```

---

## 🐘 PostgreSQL (via Docker)

```powershell
# Conectar ao PostgreSQL via CLI
docker exec -it smartserve-api-postgres-1 psql -U smartserve_user -d smartserve_db

# Comandos dentro do psql:
\dt              # Listar tabelas
\d Users         # Descrever tabela Users
\q               # Sair

# Backup do banco
docker exec smartserve-api-postgres-1 pg_dump -U smartserve_user smartserve_db > backup.sql

# Restaurar backup
docker exec -i smartserve-api-postgres-1 psql -U smartserve_user smartserve_db < backup.sql
```

**Acessar via Adminer:**
- URL: http://localhost:8080
- Sistema: PostgreSQL
- Servidor: postgres
- Usuário: smartserve_user
- Senha: smartserve_password_dev
- BD: smartserve_db

---

## 🔴 Redis

```powershell
# Conectar ao Redis CLI
docker exec -it smartserve-api-redis-1 redis-cli

# Comandos Redis:
PING             # Testar conexão
KEYS *           # Ver todas as chaves
GET chave        # Obter valor
SET chave valor  # Definir valor
DEL chave        # Deletar chave
FLUSHALL         # Limpar tudo (CUIDADO!)
EXIT             # Sair
```

---

## 🐰 RabbitMQ

**Acessar Management UI:**
- URL: http://localhost:15672
- Usuário: guest
- Senha: guest

```powershell
# Ver logs do RabbitMQ
docker-compose logs rabbitmq
```

---

## 📝 Git

```powershell
# Status
git status

# Adicionar arquivos
git add .

# Commit
git commit -m "feat: descrição da mudança"

# Push
git push origin main

# Ver histórico
git log --oneline -10

# Ver diff
git diff

# Desfazer mudanças não commitadas
git checkout -- .

# Ver branches
git branch -a
```

---

## 🔐 Secrets (Desenvolvimento)

```powershell
# Inicializar user-secrets
cd SmartServe.Api
dotnet user-secrets init

# Adicionar secret
dotnet user-secrets set "JwtSettings:SecretKey" "sua-chave-super-secreta"
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "sua-connection-string"

# Listar secrets
dotnet user-secrets list

# Remover secret
dotnet user-secrets remove "JwtSettings:SecretKey"

# Limpar todos
dotnet user-secrets clear
```

---

## 📊 Monitoramento

```powershell
# Ver uso de recursos dos containers
docker stats

# Ver logs em tempo real
docker-compose logs -f

# Ver logs da API
docker-compose logs -f api

# Ver processos
docker-compose top
```

---

## 🧹 Limpeza

```powershell
# Limpar containers parados
docker container prune

# Limpar imagens não usadas
docker image prune

# Limpar volumes não usados
docker volume prune

# Limpeza completa (CUIDADO!)
docker system prune -a --volumes
```

---

## 🚢 Build e Deploy

```powershell
# Build da imagem Docker
docker build -t smartserve-api:latest .

# Executar container da imagem
docker run -d -p 5000:80 smartserve-api:latest

# Publicar para produção
dotnet publish -c Release -o ./publish

# Criar pacote NuGet
dotnet pack -c Release
```

---

## 🎯 Comandos Mais Usados (Dia a Dia)

```powershell
# Iniciar ambiente de dev
cd C:\Users\edima\OneDrive\smartserve\smartserve-api
docker-compose up -d
cd SmartServe.Api
dotnet watch run

# Após mudanças no modelo
dotnet ef migrations add NomeDaMudanca
dotnet ef database update

# Testar
dotnet test

# Commit
git add .
git commit -m "feat: nova funcionalidade"
git push
```

---

## 🆘 Comandos de Emergência

```powershell
# RESETAR TUDO (último recurso)
docker-compose down -v
dotnet clean
dotnet nuget locals all --clear
rm -r bin, obj -Force
dotnet restore
dotnet build
docker-compose up -d
dotnet ef database update
```

---

## 📚 Referências Rápidas

- **Swagger:** http://localhost:5000/swagger
- **Health:** http://localhost:5000/api/health
- **Adminer:** http://localhost:8080
- **RabbitMQ:** http://localhost:15672
- **PostgreSQL:** localhost:5432
- **Redis:** localhost:6379

---

**Atalhos do VSCode/Rider:**
- `Ctrl + Shift + B` - Build
- `F5` - Debug
- `Ctrl + F5` - Run sem debug
- `Ctrl + .` - Quick actions
- `Ctrl + Shift + P` - Command palette

