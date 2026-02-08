# Prompt: Criar README.md

## Objetivo
Gerar um README.md completo e profissional para o projeto SmartServe API.

## Contexto do Projeto
- **Nome:** SmartServe API
- **Tipo:** Backend API RESTful
- **Framework:** ASP.NET Core 8.0+
- **Banco de Dados:** PostgreSQL
- **Infraestrutura:** Docker, Redis, RabbitMQ
- **Arquitetura:** Clean Architecture

## Estrutura do README

### 1. Cabeçalho e Badges
```markdown
# 🚀 SmartServe API

> Plataforma de conexão entre clientes e profissionais de serviços

[![.NET](https://img.shields.io/badge/.NET-8.0-512BD4?logo=dotnet)](https://dotnet.microsoft.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-336791?logo=postgresql)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker)](https://www.docker.com/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

[Demo](https://demo.smartserve.com) | [Documentação](https://docs.smartserve.com) | [API Swagger](http://localhost:5000/swagger)
```

### 2. Índice (Table of Contents)
```markdown
## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Funcionalidades](#funcionalidades)
- [Tecnologias](#tecnologias)
- [Arquitetura](#arquitetura)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Uso](#uso)
- [API Endpoints](#api-endpoints)
- [Testes](#testes)
- [Deploy](#deploy)
- [Contribuindo](#contribuindo)
- [Licença](#licença)
```

### 3. Sobre o Projeto
```markdown
## 📖 Sobre o Projeto

SmartServe é uma plataforma que conecta **clientes** a **profissionais qualificados** 
em diversas áreas de serviços. O sistema permite:

- Cadastro de clientes e profissionais
- Criação e gerenciamento de solicitações de serviço
- Sistema de propostas e negociação
- Pagamentos integrados
- Avaliações e reputação

### Problema Resolvido
Facilita a contratação de serviços confiáveis, reduzindo o tempo de busca e 
aumentando a transparência através de avaliações verificadas.
```

### 4. Funcionalidades
```markdown
## ✨ Funcionalidades

### Para Clientes
- ✅ Cadastro e autenticação
- ✅ Criação de solicitações de serviço
- ✅ Recebimento de propostas
- ✅ Sistema de pagamento seguro
- ✅ Avaliação de profissionais

### Para Profissionais
- ✅ Perfil com especializações
- ✅ Busca de oportunidades
- ✅ Envio de propostas
- ✅ Gestão de trabalhos
- ✅ Sistema de reputação

### Administrativo
- ✅ Gerenciamento de usuários
- ✅ Moderação de conteúdo
- ✅ Relatórios e analytics
- ✅ Configurações da plataforma
```

### 5. Tecnologias
```markdown
## 🛠️ Tecnologias

### Backend
- **ASP.NET Core 8.0** - Framework web
- **Entity Framework Core** - ORM
- **PostgreSQL** - Banco de dados relacional
- **Redis** - Cache distribuído
- **RabbitMQ** - Message broker

### Bibliotecas
- **FluentValidation** - Validação de dados
- **Swashbuckle** - Documentação OpenAPI/Swagger
- **Serilog** - Logging estruturado
- **MediatR** - CQRS pattern (opcional)

### DevOps
- **Docker** - Containerização
- **Docker Compose** - Orquestração local
- **GitHub Actions** - CI/CD
```

### 6. Arquitetura
```markdown
## 🏗️ Arquitetura

O projeto segue os princípios de **Clean Architecture**:

```
SmartServe.Api/
├── Domain/              # Entidades e regras de negócio
├── Application/         # Use cases, DTOs, Services
├── Infrastructure/      # Persistência, cache, messaging
└── API/                 # Controllers, middleware, startup

```

### Princípios
- **SOLID** - Design orientado a objetos
- **DRY** - Don't Repeat Yourself
- **YAGNI** - You Aren't Gonna Need It
- **Separation of Concerns** - Camadas independentes
```

### 7. Pré-requisitos
```markdown
## 📋 Pré-requisitos

- [.NET 8.0 SDK](https://dotnet.microsoft.com/download)
- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [Git](https://git-scm.com/)
- Editor: [Visual Studio](https://visualstudio.microsoft.com/) ou [Rider](https://www.jetbrains.com/rider/)

### Verificar Instalação
```bash
dotnet --version  # 8.0.x
docker --version  # 20.x+
git --version     # 2.x+
```
```

### 8. Instalação
```markdown
## 🚀 Instalação

### 1. Clonar o Repositório
```bash
git clone https://github.com/seu-usuario/smartserve-api.git
cd smartserve-api
```

### 2. Configurar Ambiente
```bash
# Copiar arquivo de configuração
cp appsettings.example.json SmartServe.Api/appsettings.json

# Editar se necessário
```

### 3. Iniciar Containers
```bash
docker-compose up -d
```

### 4. Aplicar Migrations
```bash
cd SmartServe.Api
dotnet ef database update
```

### 5. Executar a API
```bash
dotnet run
```

Acesse: **http://localhost:5000/swagger**
```

### 9. API Endpoints
```markdown
## 🔌 API Endpoints

### Autenticação
```http
POST   /api/auth/register       # Registrar usuário
POST   /api/auth/login          # Login
POST   /api/auth/refresh        # Refresh token
```

### Profissionais
```http
GET    /api/professionals       # Listar profissionais
GET    /api/professionals/{id}  # Detalhes
POST   /api/professionals       # Criar perfil
PUT    /api/professionals/{id}  # Atualizar
DELETE /api/professionals/{id}  # Remover
```

### Solicitações
```http
GET    /api/servicerequests              # Listar
POST   /api/servicerequests              # Criar
GET    /api/servicerequests/{id}         # Detalhes
PUT    /api/servicerequests/{id}/status  # Atualizar status
```

**Documentação completa:** [Swagger UI](http://localhost:5000/swagger)
```

### 10. Variáveis de Ambiente
```markdown
## ⚙️ Configuração

### Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto:

```env
# Database
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=smartserve_db
DATABASE_USER=smartserve_user
DATABASE_PASSWORD=smartserve_password_dev

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# RabbitMQ
RABBITMQ_HOST=localhost
RABBITMQ_PORT=5672
RABBITMQ_USER=smartserve
RABBITMQ_PASSWORD=smartserve_password_dev

# JWT
JWT_SECRET=your-super-secret-key-change-in-production
JWT_EXPIRATION_HOURS=24

# Application
ASPNETCORE_ENVIRONMENT=Development
ASPNETCORE_URLS=http://+:5000
```
```

### 11. Testes
```markdown
## 🧪 Testes

### Executar Todos os Testes
```bash
dotnet test
```

### Executar com Cobertura
```bash
dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover
```

### Teste de Integração
```bash
dotnet test --filter Category=Integration
```
```

### 12. Deploy
```markdown
## 🚢 Deploy

### Docker
```bash
docker build -t smartserve-api .
docker run -p 5000:5000 smartserve-api
```

### Azure App Service
```bash
az webapp up --name smartserve-api --resource-group smartserve-rg
```

### Kubernetes
```bash
kubectl apply -f k8s/
```
```

### 13. Contribuindo
```markdown
## 🤝 Contribuindo

Contribuições são bem-vindas!

1. Fork o projeto
2. Crie uma branch: `git checkout -b feature/nova-feature`
3. Commit: `git commit -m 'Adiciona nova feature'`
4. Push: `git push origin feature/nova-feature`
5. Abra um Pull Request

### Convenções
- Commits em inglês
- Seguir padrões de código do projeto
- Adicionar testes para novas funcionalidades
- Atualizar documentação quando necessário
```

### 14. Licença e Contato
```markdown
## 📄 Licença

Este projeto está sob a licença MIT. Veja [LICENSE](LICENSE) para mais detalhes.

## 📧 Contato

- **Desenvolvedor:** Seu Nome
- **Email:** seu.email@example.com
- **LinkedIn:** [seu-perfil](https://linkedin.com/in/seu-perfil)
- **GitHub:** [@seu-usuario](https://github.com/seu-usuario)

---

⭐ **Se este projeto foi útil, considere dar uma estrela!**
```

## Checklist do README

- [ ] Título e descrição clara
- [ ] Badges informativos
- [ ] Índice navegável
- [ ] Seção "Sobre o Projeto"
- [ ] Lista de funcionalidades
- [ ] Stack de tecnologias
- [ ] Diagrama de arquitetura
- [ ] Pré-requisitos detalhados
- [ ] Instruções de instalação passo a passo
- [ ] Exemplos de uso
- [ ] Documentação de API
- [ ] Instruções de teste
- [ ] Guia de deploy
- [ ] Guia de contribuição
- [ ] Licença e contato

## Dicas de Escrita

1. **Seja claro e objetivo** - Usuários devem entender rapidamente
2. **Use emojis com moderação** - Tornam mais visual, mas não exagere
3. **Código executável** - Todos os exemplos devem funcionar
4. **Mantenha atualizado** - README desatualizado confunde
5. **Screenshots** - Imagens valem mais que mil palavras
6. **Links funcionais** - Teste todos os links antes de commitar

## Exemplo de Uso

```
@workspace Use o prompt .github/prompts/docs/create-readme.prompt.md 
para gerar um README.md completo para o SmartServe API
```

