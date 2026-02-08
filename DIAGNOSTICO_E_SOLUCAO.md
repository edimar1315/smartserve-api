# Diagnóstico e Solução de Problemas - SmartServe API

## Data: 2026-02-06

---

## ❌ PROBLEMAS IDENTIFICADOS

### 1. Docker Daemon Não Está Rodando
**Erro detectado:**
```
error during connect: in the default daemon configuration on Windows, 
the docker client must be run with elevated privileges to connect: 
Get "http://%2F%2F.%2Fpipe%2Fdocker_engine/v1.49/info": 
open //./pipe/docker_engine: The system cannot find the file specified.
```

**Causa:**
- Docker Desktop não está em execução
- O daemon do Docker (processo em background) não iniciou

**Impacto:**
- `docker-compose up` falha
- Containers PostgreSQL, Redis e RabbitMQ não sobem
- Migrations não podem ser aplicadas no banco

---

### 2. Migrations Não Foram Criadas
**Problema:**
- Pasta `Infrastructure/Persistence/Migrations` não existe
- Comando `dotnet ef migrations add` não gerou arquivos

**Causa:**
- `dotnet-ef` tool pode não estar instalada ou não estar no PATH
- Build pode ter falhado silenciosamente

**Impacto:**
- `dotnet ef database update` não pode rodar
- Tabelas não são criadas no PostgreSQL

---

## ✅ SOLUÇÕES IMPLEMENTADAS

### Arquivos Criados/Corrigidos:

1. ✅ **SmartServeDbContext.cs** - Adicionado `using Microsoft.EntityFrameworkCore;`
2. ✅ **DesignTimeDbContextFactory.cs** - Criado para permitir EF CLI funcionar
3. ✅ **setup.ps1** - Script de setup automatizado
4. ✅ **.env.local.example** - Template de variáveis de ambiente
5. ✅ **.gitignore** - Atualizado para ignorar secrets
6. ✅ **fix-setup.ps1** - Script de correção robusto

### Pacotes Instalados:
- ✅ Microsoft.EntityFrameworkCore.Design (10.0.2)
- ✅ Npgsql.EntityFrameworkCore.PostgreSQL (10.0.0)

---

## 🔧 COMO RESOLVER (PASSO A PASSO)

### ETAPA 1: Iniciar Docker Desktop

**Abra o Docker Desktop manualmente:**
1. Pressione `Win + S` e digite "Docker Desktop"
2. Clique no aplicativo Docker Desktop
3. **AGUARDE** até ver a mensagem "Docker Desktop is running" (ícone verde na bandeja)
4. Isso pode levar 30-60 segundos

**Verificar se está funcionando:**
```powershell
docker info
```
✅ **Sucesso:** Deve mostrar informações do Server (CPUs, Memory, etc.)  
❌ **Falha:** Se ainda mostrar erro, aguarde mais 30 segundos e tente novamente

---

### ETAPA 2: Executar Script de Correção

**Abra PowerShell no diretório do projeto:**
```powershell
cd C:\Users\edima\OneDrive\smartserve\smartserve-api
```

**Execute o script:**
```powershell
powershell -ExecutionPolicy Bypass -File .\fix-setup.ps1
```

**O que o script faz:**
1. ✅ Verifica se Docker Desktop está rodando
2. ✅ Aguarda daemon Docker ficar pronto (com retries)
3. ✅ Instala `dotnet-ef` global tool (se necessário)
4. ✅ Executa `docker-compose up -d`
5. ✅ Cria migration `InitialCreate`
6. ✅ Aplica migrations no PostgreSQL

---

### ETAPA 3: Verificação Manual (Se o Script Falhar)

#### 3.1 Verificar Docker
```powershell
# Ver containers rodando
docker-compose ps

# Deve mostrar:
# postgres    Up   0.0.0.0:5432->5432/tcp
# redis       Up   0.0.0.0:6379->6379/tcp
# rabbitmq    Up   5672/tcp, 15672/tcp
# adminer     Up   0.0.0.0:8080->8080/tcp
```

#### 3.2 Instalar dotnet-ef (se necessário)
```powershell
dotnet tool install --global dotnet-ef
$env:PATH += ";$env:USERPROFILE\.dotnet\tools"
dotnet ef --version
```

#### 3.3 Gerar Migrations (se não foram criadas)
```powershell
cd SmartServe.Api
dotnet ef migrations add InitialCreate -o Infrastructure/Persistence/Migrations
```

✅ **Sucesso:** Verá mensagens como:
```
Build started...
Build succeeded.
Done. To undo this action, use 'ef migrations remove'
```

#### 3.4 Aplicar Migrations
```powershell
dotnet ef database update
```

✅ **Sucesso:** Verá:
```
Build started...
Build succeeded.
Applying migration '20260206_InitialCreate'.
Done.
```

---

### ETAPA 4: Testar a API

#### 4.1 Executar a aplicação
```powershell
cd C:\Users\edima\OneDrive\smartserve\smartserve-api\SmartServe.Api
dotnet run
```

✅ **Sucesso:** Verá:
```
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5000
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
```

#### 4.2 Testar endpoints

**Health Check (no navegador ou PowerShell):**
```powershell
# PowerShell
Invoke-WebRequest -Uri http://localhost:5000/api/health | Select-Object -Expand Content

# Navegador
http://localhost:5000/api/health
```

✅ **Resposta esperada:**
```json
{
  "status": "healthy",
  "timestamp": "2026-02-06T..."
}
```

**Swagger UI:**
```
http://localhost:5000/swagger
```

**Adminer (gerenciar PostgreSQL):**
```
http://localhost:8080
```
- Sistema: PostgreSQL
- Servidor: postgres
- Usuário: smartserve_user
- Senha: smartserve_password_dev
- Base de dados: smartserve_db

---

## 🐛 TROUBLESHOOTING

### Problema: "dotnet ef: command not found"
**Solução:**
```powershell
# Adicionar ao PATH da sessão
$env:PATH += ";$env:USERPROFILE\.dotnet\tools"

# Ou adicionar permanentemente (variáveis de ambiente do sistema)
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$env:USERPROFILE\.dotnet\tools", "User")
```

### Problema: Docker Compose falha com "version is obsolete"
**Solução:** Já corrigido - a mensagem é apenas um warning, não um erro.

### Problema: "Build failed" ao gerar migrations
**Solução:**
```powershell
cd SmartServe.Api
dotnet build
# Ver erros detalhados e corrigir
```

### Problema: Migrations aplicadas mas tabelas não aparecem
**Solução:**
```powershell
# Conectar ao PostgreSQL via Adminer ou CLI
docker exec -it smartserve-api-postgres-1 psql -U smartserve_user -d smartserve_db

# Listar tabelas
\dt

# Deve mostrar: Users, Professionals, Clients, ServiceRequests, Proposals, etc.
```

---

## 📋 CHECKLIST DE VALIDAÇÃO

Depois de executar todos os passos, verifique:

- [ ] `docker info` retorna informações do Server sem erros
- [ ] `docker-compose ps` mostra 4 containers UP
- [ ] `dotnet ef --version` mostra versão (ex: 10.0.2)
- [ ] Pasta `SmartServe.Api/Infrastructure/Persistence/Migrations` existe com arquivos .cs
- [ ] `dotnet ef database update` executa sem erro
- [ ] `dotnet run` inicia a aplicação na porta 5000
- [ ] `http://localhost:5000/api/health` retorna status "healthy"
- [ ] `http://localhost:5000/swagger` abre a documentação da API
- [ ] Adminer conecta ao PostgreSQL e mostra tabelas criadas

---

## 🚀 PRÓXIMOS PASSOS (APÓS CORREÇÃO)

### 1. Commit e Push
```powershell
cd C:\Users\edima\OneDrive\smartserve\smartserve-api
git add .
git commit -m "fix: corrigir setup Docker e migrations, adicionar scripts de diagnóstico"
git push -u origin main
```

### 2. Configurar GitHub Secrets (para CI/CD)
No repositório GitHub: Settings > Secrets and variables > Actions

Adicionar:
- `CONNECTION_STRING` - connection string de produção
- `JWT_SECRET` - secret key para JWT (gerar um seguro)

### 3. Criar Controllers
- AuthController (login, register, refresh token)
- ProfessionalsController (CRUD + busca)
- ServiceRequestsController (criar, listar, atualizar status)
- ProposalsController (criar proposta, aceitar/rejeitar)

### 4. Implementar Autenticação JWT
- Instalar: `dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer`
- Configurar em Program.cs

### 5. Testes
- Criar projeto de testes: `dotnet new xunit -n SmartServe.Tests`
- Testes unitários para Services
- Testes de integração com TestContainers

---

## 📞 SUPORTE

Se após seguir todos os passos ainda houver problemas:

1. Copie a saída completa do comando que falhou
2. Execute `docker-compose logs` para ver logs dos containers
3. Execute `dotnet build -v detailed` para ver detalhes de build
4. Compartilhe os logs para análise

---

## ✅ STATUS ATUAL (PÓS-CORREÇÃO)

### Arquitetura
- ✅ Domain Entities definidas (User, Professional, Client, ServiceRequest, Proposal, Payment)
- ✅ DbContext configurado com relacionamentos
- ✅ Program.cs com DI, Swagger, CORS, Health check
- ✅ Middleware de Exception Handling e Request Logging
- ✅ DesignTimeDbContextFactory para EF CLI

### Infraestrutura
- ✅ Docker Compose com PostgreSQL, Redis, RabbitMQ, Adminer
- ✅ Scripts de setup automatizados
- ✅ .gitignore protegendo secrets
- ✅ Template de .env.local

### Pendente (Implementar)
- ⏳ Migrations aplicadas ao banco
- ⏳ Controllers (Auth, Professionals, ServiceRequests, Proposals)
- ⏳ Services / Use Cases
- ⏳ DTOs e Validators
- ⏳ Autenticação JWT
- ⏳ Testes automatizados
- ⏳ CI/CD (GitHub Actions)

---

**Gerado em:** 2026-02-06  
**Versão do documento:** 1.0  
**Última atualização:** Após correção do DbContext e criação de scripts de setup

