# SmartServe API 🚀

Plataforma SaaS B2B de matching inteligente entre profissionais de serviço e clientes.

## 📋 Estrutura do Projeto

```
smartserve-api/
├── SmartServe.Api/                  # Projeto principal
│   ├── Domain/
│   │   └── Entities/               # Entidades de domínio
│   │       ├── User.cs
│   │       ├── Professional.cs
│   │       ├── Client.cs
│   │       ├── Specialization.cs
│   │       ├── ServiceRequest.cs
│   │       ├── Proposal.cs
│   │       └── Payment.cs
│   ├── Infrastructure/
│   │   └── Persistence/
│   │       ├── SmartServeDbContext.cs
│   │       └── Migrations/
│   ├── Application/
│   │   ├── DTOs/
│   │   ├── Services/
│   │   ├── UseCases/
│   │   └── Validators/
│   ├── Middleware/
│   │   ├── ExceptionHandlingMiddleware.cs
│   │   └── RequestLoggingMiddleware.cs
│   └── Program.cs
├── docker-compose.yml               # Orquestração de containers
├── Dockerfile                       # Build da aplicação
├── .gitignore
└── setup.bat                        # Script de configuração (Windows)
```

## 🛠️ Pré-requisitos

- .NET 10 SDK
- Docker e Docker Compose
- PostgreSQL (via Docker)
- Redis (via Docker)
- RabbitMQ (via Docker)

## 🚀 Quickstart

### Windows

1. **Execute o script de setup:**
```bash
.\setup.bat
```

2. **Inicie os containers:**
```bash
docker-compose up -d
```

3. **Aguarde o PostgreSQL estar pronto:**
```bash
docker-compose ps
```

4. **Execute as migrations:**
```bash
cd SmartServe.Api
dotnet ef database update
```

5. **Inicie a API:**
```bash
dotnet run
```

A API estará disponível em: **http://localhost:5000**

### Linux/Mac

```bash
cd SmartServe.Api

# 1. Restaurar dependências
dotnet restore

# 2. Compilar
dotnet build -c Release

# 3. Iniciar containers
cd ..
docker-compose up -d

# 4. Criar migration
cd SmartServe.Api
dotnet ef migrations add InitialCreate -o Infrastructure/Persistence/Migrations

# 5. Atualizar banco de dados
dotnet ef database update

# 6. Executar a API
dotnet run
```

## 📚 Documentação da API

Swagger UI disponível em: **http://localhost:5000/swagger**

## 🗄️ Banco de Dados

### Strings de Conexão

- **PostgreSQL:** `Host=localhost;Port=5432;Database=smartserve_db;Username=smartserve_user;Password=smartserve_password_dev`
- **Redis:** `localhost:6379`
- **RabbitMQ:** `amqp://smartserve:smartserve_password_dev@localhost:5672/`

### Adminer (UI do Banco)

Acesse em: **http://localhost:8080**

Credenciais:
- Server: `postgres`
- User: `smartserve_user`
- Password: `smartserve_password_dev`
- Database: `smartserve_db`

## 🔌 Serviços

| Serviço | Container | Porta | Variáveis |
|---------|-----------|-------|-----------|
| PostgreSQL | smartserve-db | 5432 | user: smartserve_user, pass: smartserve_password_dev |
| Redis | smartserve-redis | 6379 | - |
| RabbitMQ | smartserve-rabbitmq | 5672, 15672 | user: smartserve, pass: smartserve_password_dev |
| Adminer | smartserve-adminer | 8080 | - |

## 📝 Entidades Principais

### User (Abstrata)
- Professional (Profissional)
- Client (Cliente)

### Professional
- Especialidades (many-to-many com Specialization)
- Propostas
- Avaliações

### Client
- Solicitações de serviço
- Pagamentos

### ServiceRequest
- Descrição do serviço
- Localização
- Orçamento
- Especialidade

### Proposal
- Preço proposto
- Profissional
- Status (PENDING, ACCEPTED, REJECTED)

### Payment
- Valor
- Método de pagamento
- Status

## 🔧 Configuração de Ambiente

Edite `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "..."
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  },
  "Redis": {
    "ConnectionString": "localhost:6379"
  },
  "RabbitMQ": {
    "Hostname": "localhost",
    "Port": 5672,
    "Username": "smartserve",
    "Password": "smartserve_password_dev"
  }
}
```

## 🧹 Limpeza

Para remover containers e volumes:

```bash
docker-compose down -v
```

## 📦 Dependências Principais

- `Microsoft.EntityFrameworkCore.PostgreSQL` - ORM
- `StackExchange.Redis` - Cache
- `RabbitMQ.Client` - Message Queue
- `FluentValidation` - Validação
- `Swashbuckle.AspNetCore` - Swagger/OpenAPI

## ✅ Checklist de Setup

- [x] Estrutura de pastas criada
- [x] Entidades de domínio definidas
- [x] DbContext configurado
- [x] Middleware de exceções e logging
- [x] Docker Compose com serviços
- [x] Configurações de appsettings
- [ ] Controllers e endpoints
- [ ] DTOs e mappers
- [ ] Services e use cases
- [ ] Validadores Fluent
- [ ] Testes unitários
- [ ] CI/CD (GitHub Actions)

## 🤝 Próximos Passos

1. Criar Controllers para Professional, Client, ServiceRequest
2. Implementar DTOs e mappers
3. Criar Services para lógica de negócio
4. Implementar validadores Fluent
5. Adicionar testes unitários
6. Configurar GitHub Actions para CI/CD

## 📞 Suporte

Para mais informações, consulte a documentação completa em `/files/README.md`

---

**Desenvolvido com ❤️ para SmartServe**

