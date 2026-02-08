# Prompt: Gerar Feature Completa

## Objetivo
Criar uma feature completa seguindo Clean Architecture no projeto SmartServe API.

## Contexto do Projeto
- **Framework:** ASP.NET Core 8.0+
- **ORM:** Entity Framework Core
- **Database:** PostgreSQL
- **Arquitetura:** Clean Architecture (Domain, Application, Infrastructure, API)
- **Validação:** FluentValidation
- **Documentação:** Swagger/OpenAPI

## Checklist de Implementação
- [ ] **Entidade** no `Domain/Entities/`
- [ ] **DTOs** no `Application/DTOs/` (Create, Update, Response)
- [ ] **Validator** no `Application/Validators/` com FluentValidation
- [ ] **Service** e **Interface** no `Application/Services/`
- [ ] **Controller** na raiz do projeto API
- [ ] **Configuração** no `Program.cs` (DI, Services)
- [ ] **Documentação XML** em todos os métodos públicos
- [ ] **Testes unitários** (opcional, mas recomendado)

## Estrutura de Arquivos a Criar

```
SmartServe.Api/
├── Domain/Entities/
│   └── {NomeDaEntidade}.cs
├── Application/
│   ├── DTOs/
│   │   ├── {Entidade}Dto.cs
│   │   ├── Create{Entidade}Dto.cs
│   │   └── Update{Entidade}Dto.cs
│   ├── Services/
│   │   ├── I{Entidade}Service.cs
│   │   └── {Entidade}Service.cs
│   └── Validators/
│       ├── Create{Entidade}Validator.cs
│       └── Update{Entidade}Validator.cs
└── Controllers/
    └── {Entidade}Controller.cs
```

## Padrões de Código

### 1. Entidade (Domain)
```csharp
// Herdar de classe base se aplicável
// Propriedades com validação no banco (Required, MaxLength)
// Navigation properties para relacionamentos
// Created/Updated timestamps
```

### 2. DTOs (Application)
```csharp
// DTOs para Request (Create, Update)
// DTOs para Response (incluir IDs, timestamps)
// Usar record types quando possível
// Propriedades nullables quando opcional
```

### 3. Validators (FluentValidation)
```csharp
// Validações de negócio
// RuleFor para cada propriedade
// Mensagens de erro claras em português
// Validações customizadas quando necessário
```

### 4. Services
```csharp
// Interface com contrato de métodos
// CRUD completo: GetAll, GetById, Create, Update, Delete
// Métodos assíncronos (async/await)
// Tratamento de exceções
// Retornar DTOs, não entidades
```

### 5. Controller
```csharp
// [ApiController] e [Route("api/[controller]")]
// Injetar service via construtor
// Endpoints RESTful com verbos HTTP corretos
// Retornar ActionResult<T> ou IActionResult
// Status codes HTTP corretos (200, 201, 204, 400, 404)
// Documentação XML para Swagger
// Validação automática com [ApiController]
```

## Exemplo de Input

**Usuário fornece:**
```
Feature: Gerenciamento de Avaliações (Reviews)
Entidade: Review
Propriedades:
- ProfessionalId (FK)
- ClientId (FK)
- ServiceRequestId (FK)
- Rating (1-5)
- Comment (string, opcional)
- CreatedAt
```

## Output Esperado

O assistente deve gerar todos os arquivos listados no checklist, com código completo e funcional.

## Validações Importantes
- ✅ Seguir convenções de nomenclatura C#
- ✅ Usar async/await em operações de I/O
- ✅ Documentação XML em métodos públicos
- ✅ Tratamento adequado de erros
- ✅ Validações de negócio no Validator
- ✅ DTOs separados para Request/Response
- ✅ Controllers enxutos (delegam lógica para Services)

## Integração com DbContext

Lembre-se de adicionar o DbSet no `SmartServeDbContext.cs`:
```csharp
public DbSet<{Entidade}> {Entidades} { get; set; }
```

E configurar relacionamentos no `OnModelCreating` se necessário.

## Após a Implementação

1. Adicionar injeção de dependência no `Program.cs`
2. Criar migration: `dotnet ef migrations add Add{Entidade}`
3. Atualizar banco: `dotnet ef database update`
4. Testar endpoints via Swagger

## Exemplo de Uso

```
@workspace Use o prompt .github/prompts/code/generate-feature.prompt.md 
para criar a feature de Reviews com as seguintes propriedades:
- ProfessionalId, ClientId, ServiceRequestId (FKs)
- Rating (int 1-5)
- Comment (string opcional)
- CreatedAt (DateTimeOffset)
```

