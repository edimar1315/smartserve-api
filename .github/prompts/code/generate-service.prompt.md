# Prompt: Gerar Service (Application Layer)

## Objetivo
Criar uma camada de serviço completa com interface, implementação e lógica de negócio no padrão SmartServe API.

## Contexto do Projeto
- **Framework:** ASP.NET Core 8.0+
- **ORM:** Entity Framework Core
- **Padrão:** Repository/Service Pattern
- **Validação:** FluentValidation
- **Mapeamento:** Manual ou AutoMapper

## Estrutura de Arquivos

```
Application/
├── Services/
│   ├── I{Entidade}Service.cs        # Interface do serviço
│   └── {Entidade}Service.cs         # Implementação
```

## Template - Interface (I{Entidade}Service.cs)

```csharp
using SmartServe.Api.Application.DTOs;

namespace SmartServe.Api.Application.Services;

/// <summary>
/// Interface do serviço de gerenciamento de {Entidade}
/// </summary>
public interface I{Entidade}Service
{
    /// <summary>
    /// Obtém todos os {entidades}
    /// </summary>
    Task<IEnumerable<{Entidade}Dto>> GetAllAsync();
    
    /// <summary>
    /// Obtém um {entidade} por ID
    /// </summary>
    Task<{Entidade}Dto?> GetByIdAsync(Guid id);
    
    /// <summary>
    /// Cria um novo {entidade}
    /// </summary>
    Task<{Entidade}Dto> CreateAsync(Create{Entidade}Dto dto);
    
    /// <summary>
    /// Atualiza um {entidade} existente
    /// </summary>
    Task UpdateAsync(Guid id, Update{Entidade}Dto dto);
    
    /// <summary>
    /// Remove um {entidade}
    /// </summary>
    Task DeleteAsync(Guid id);
    
    /// <summary>
    /// Verifica se um {entidade} existe
    /// </summary>
    Task<bool> ExistsAsync(Guid id);
}
```

## Template - Implementação ({Entidade}Service.cs)

```csharp
using Microsoft.EntityFrameworkCore;
using SmartServe.Api.Application.DTOs;
using SmartServe.Api.Domain.Entities;
using SmartServe.Api.Infrastructure.Persistence;

namespace SmartServe.Api.Application.Services;

/// <summary>
/// Implementação do serviço de gerenciamento de {Entidade}
/// </summary>
public class {Entidade}Service : I{Entidade}Service
{
    private readonly SmartServeDbContext _context;
    private readonly ILogger<{Entidade}Service> _logger;

    public {Entidade}Service(
        SmartServeDbContext context,
        ILogger<{Entidade}Service> logger)
    {
        _context = context;
        _logger = logger;
    }

    /// <inheritdoc />
    public async Task<IEnumerable<{Entidade}Dto>> GetAllAsync()
    {
        var entities = await _context.{Entidades}
            .AsNoTracking()
            // .Include(x => x.RelatedEntity) // Se houver relacionamentos
            .ToListAsync();

        return entities.Select(MapToDto);
    }

    /// <inheritdoc />
    public async Task<{Entidade}Dto?> GetByIdAsync(Guid id)
    {
        var entity = await _context.{Entidades}
            .AsNoTracking()
            // .Include(x => x.RelatedEntity)
            .FirstOrDefaultAsync(x => x.Id == id);

        return entity == null ? null : MapToDto(entity);
    }

    /// <inheritdoc />
    public async Task<{Entidade}Dto> CreateAsync(Create{Entidade}Dto dto)
    {
        var entity = new {Entidade}
        {
            Id = Guid.NewGuid(),
            // Mapear propriedades do DTO
            CreatedAt = DateTimeOffset.UtcNow
        };

        _context.{Entidades}.Add(entity);
        await _context.SaveChangesAsync();

        _logger.LogInformation("{Entidade} criado com ID {Id}", entity.Id);

        return MapToDto(entity);
    }

    /// <inheritdoc />
    public async Task UpdateAsync(Guid id, Update{Entidade}Dto dto)
    {
        var entity = await _context.{Entidades}
            .FirstOrDefaultAsync(x => x.Id == id);

        if (entity == null)
        {
            throw new KeyNotFoundException($"{Entidade} com ID {id} não encontrado");
        }

        // Atualizar propriedades
        // entity.Property = dto.Property;
        entity.UpdatedAt = DateTimeOffset.UtcNow;

        await _context.SaveChangesAsync();

        _logger.LogInformation("{Entidade} {Id} atualizado", id);
    }

    /// <inheritdoc />
    public async Task DeleteAsync(Guid id)
    {
        var entity = await _context.{Entidades}
            .FirstOrDefaultAsync(x => x.Id == id);

        if (entity == null)
        {
            throw new KeyNotFoundException($"{Entidade} com ID {id} não encontrado");
        }

        _context.{Entidades}.Remove(entity);
        await _context.SaveChangesAsync();

        _logger.LogInformation("{Entidade} {Id} removido", id);
    }

    /// <inheritdoc />
    public async Task<bool> ExistsAsync(Guid id)
    {
        return await _context.{Entidades}
            .AnyAsync(x => x.Id == id);
    }

    #region Mapeamento

    private static {Entidade}Dto MapToDto({Entidade} entity)
    {
        return new {Entidade}Dto
        {
            Id = entity.Id,
            // Mapear propriedades
            CreatedAt = entity.CreatedAt
        };
    }

    #endregion
}
```

## Boas Práticas

### 1. Sempre Usar Async/Await
```csharp
// ✅ Correto
public async Task<List<Item>> GetAllAsync()
{
    return await _context.Items.ToListAsync();
}

// ❌ Evitar
public Task<List<Item>> GetAll()
{
    return _context.Items.ToListAsync(); // Missing await
}
```

### 2. AsNoTracking para Consultas Read-Only
```csharp
// ✅ Performance otimizada
var items = await _context.Items
    .AsNoTracking()
    .ToListAsync();
```

### 3. Includes Explícitos
```csharp
// ✅ Evita lazy loading e N+1
var professional = await _context.Professionals
    .Include(p => p.Specializations)
    .Include(p => p.ServiceRequests)
    .FirstOrDefaultAsync(p => p.Id == id);
```

### 4. Validações de Negócio
```csharp
public async Task CreateAsync(CreateProposalDto dto)
{
    // Validar regras de negócio
    var serviceRequest = await _context.ServiceRequests
        .FindAsync(dto.ServiceRequestId);
    
    if (serviceRequest?.Status != ServiceRequestStatus.Open)
    {
        throw new InvalidOperationException(
            "Propostas só podem ser criadas para solicitações abertas");
    }
    
    // Criar a proposta
    // ...
}
```

### 5. Tratamento de Concorrência
```csharp
try
{
    await _context.SaveChangesAsync();
}
catch (DbUpdateConcurrencyException ex)
{
    _logger.LogError(ex, "Erro de concorrência ao atualizar {Entidade}", id);
    throw;
}
```

### 6. Soft Delete (Opcional)
```csharp
public async Task DeleteAsync(Guid id)
{
    var entity = await _context.Items.FindAsync(id);
    if (entity == null)
        throw new KeyNotFoundException();
    
    // Soft delete
    entity.IsDeleted = true;
    entity.DeletedAt = DateTimeOffset.UtcNow;
    
    await _context.SaveChangesAsync();
}
```

## Métodos Adicionais Comuns

### Paginação
```csharp
public async Task<PagedResult<{Entidade}Dto>> GetPagedAsync(
    int page, 
    int pageSize)
{
    var query = _context.{Entidades}.AsNoTracking();
    
    var total = await query.CountAsync();
    var items = await query
        .Skip((page - 1) * pageSize)
        .Take(pageSize)
        .ToListAsync();
    
    return new PagedResult<{Entidade}Dto>
    {
        Items = items.Select(MapToDto),
        Page = page,
        PageSize = pageSize,
        TotalCount = total
    };
}
```

### Busca/Filtro
```csharp
public async Task<IEnumerable<{Entidade}Dto>> SearchAsync(string query)
{
    var entities = await _context.{Entidades}
        .AsNoTracking()
        .Where(x => x.Name.Contains(query) || x.Description.Contains(query))
        .ToListAsync();
    
    return entities.Select(MapToDto);
}
```

### Ativação/Desativação
```csharp
public async Task ActivateAsync(Guid id)
{
    var entity = await _context.{Entidades}.FindAsync(id);
    if (entity == null)
        throw new KeyNotFoundException();
    
    entity.IsActive = true;
    await _context.SaveChangesAsync();
}
```

## Checklist de Implementação

- [ ] Interface com contrato de métodos
- [ ] Implementação com injeção de dependência
- [ ] CRUD completo (GetAll, GetById, Create, Update, Delete)
- [ ] Métodos assíncronos (async/await)
- [ ] AsNoTracking em queries read-only
- [ ] Includes para relacionamentos
- [ ] Validações de negócio
- [ ] Logging de operações importantes
- [ ] Tratamento de exceções
- [ ] Mapeamento entre Entity e DTO
- [ ] Documentação XML em métodos públicos

## Exemplo de Input

```
Entidade: Review
DbSet: Reviews
Propriedades: ProfessionalId, ClientId, Rating, Comment
Relacionamentos: Professional, Client, ServiceRequest
```

## Exemplo de Uso

```
@workspace Use o prompt .github/prompts/code/generate-service.prompt.md 
para criar o service da entidade Review incluindo validações de negócio
```

## Integração no Program.cs

Após criar o service, registrar no DI:
```csharp
builder.Services.AddScoped<I{Entidade}Service, {Entidade}Service>();
```

## Testes Recomendados

1. **Unit Tests** - Testar lógica de negócio isolada
2. **Integration Tests** - Testar operações com banco de dados
3. **Mocks** - Usar Moq para mockar DbContext em unit tests

