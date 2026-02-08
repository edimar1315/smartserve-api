# Prompt: Gerar Controller ASP.NET Core

## Objetivo
Criar um controller RESTful completo seguindo as convenções do ASP.NET Core e padrões do SmartServe API.

## Contexto do Projeto
- **Framework:** ASP.NET Core 8.0+
- **Padrão:** API RESTful com injeção de dependência
- **Validação:** FluentValidation + [ApiController]
- **Documentação:** Swagger com XML Comments
- **Response:** ActionResult<T> com status codes corretos

## Template de Controller

```csharp
using Microsoft.AspNetCore.Mvc;
using SmartServe.Api.Application.DTOs;
using SmartServe.Api.Application.Services;

namespace SmartServe.Api.Controllers;

/// <summary>
/// Controller para gerenciamento de {Entidade}
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class {Entidade}Controller : ControllerBase
{
    private readonly I{Entidade}Service _service;
    private readonly ILogger<{Entidade}Controller> _logger;

    public {Entidade}Controller(
        I{Entidade}Service service,
        ILogger<{Entidade}Controller> logger)
    {
        _service = service;
        _logger = logger;
    }

    // Métodos CRUD aqui
}
```

## Endpoints a Implementar

### 1. GET - Listar Todos
```csharp
/// <summary>
/// Obtém a lista de todos os {entidades}
/// </summary>
/// <returns>Lista de {entidades}</returns>
/// <response code="200">Lista retornada com sucesso</response>
[HttpGet]
[ProducesResponseType(typeof(IEnumerable<{Entidade}Dto>), StatusCodes.Status200OK)]
public async Task<ActionResult<IEnumerable<{Entidade}Dto>>> GetAll()
{
    var items = await _service.GetAllAsync();
    return Ok(items);
}
```

### 2. GET - Buscar por ID
```csharp
/// <summary>
/// Obtém um {entidade} específico por ID
/// </summary>
/// <param name="id">ID do {entidade}</param>
/// <returns>Dados do {entidade}</returns>
/// <response code="200">{Entidade} encontrado</response>
/// <response code="404">{Entidade} não encontrado</response>
[HttpGet("{id:guid}")]
[ProducesResponseType(typeof({Entidade}Dto), StatusCodes.Status200OK)]
[ProducesResponseType(StatusCodes.Status404NotFound)]
public async Task<ActionResult<{Entidade}Dto>> GetById(Guid id)
{
    var item = await _service.GetByIdAsync(id);
    
    if (item == null)
    {
        _logger.LogWarning("{Entidade} com ID {Id} não encontrado", id);
        return NotFound(new { message = $"{Entidade} não encontrado" });
    }
    
    return Ok(item);
}
```

### 3. POST - Criar
```csharp
/// <summary>
/// Cria um novo {entidade}
/// </summary>
/// <param name="dto">Dados para criação</param>
/// <returns>{Entidade} criado</returns>
/// <response code="201">{Entidade} criado com sucesso</response>
/// <response code="400">Dados inválidos</response>
[HttpPost]
[ProducesResponseType(typeof({Entidade}Dto), StatusCodes.Status201Created)]
[ProducesResponseType(StatusCodes.Status400BadRequest)]
public async Task<ActionResult<{Entidade}Dto>> Create([FromBody] Create{Entidade}Dto dto)
{
    var created = await _service.CreateAsync(dto);
    
    _logger.LogInformation("{Entidade} criado com ID {Id}", created.Id);
    
    return CreatedAtAction(
        nameof(GetById), 
        new { id = created.Id }, 
        created);
}
```

### 4. PUT - Atualizar
```csharp
/// <summary>
/// Atualiza um {entidade} existente
/// </summary>
/// <param name="id">ID do {entidade}</param>
/// <param name="dto">Dados para atualização</param>
/// <returns>Sem conteúdo</returns>
/// <response code="204">Atualização realizada com sucesso</response>
/// <response code="400">Dados inválidos</response>
/// <response code="404">{Entidade} não encontrado</response>
[HttpPut("{id:guid}")]
[ProducesResponseType(StatusCodes.Status204NoContent)]
[ProducesResponseType(StatusCodes.Status400BadRequest)]
[ProducesResponseType(StatusCodes.Status404NotFound)]
public async Task<IActionResult> Update(Guid id, [FromBody] Update{Entidade}Dto dto)
{
    var exists = await _service.ExistsAsync(id);
    if (!exists)
    {
        _logger.LogWarning("Tentativa de atualizar {Entidade} inexistente: {Id}", id);
        return NotFound(new { message = $"{Entidade} não encontrado" });
    }
    
    await _service.UpdateAsync(id, dto);
    
    _logger.LogInformation("{Entidade} {Id} atualizado com sucesso", id);
    
    return NoContent();
}
```

### 5. DELETE - Remover
```csharp
/// <summary>
/// Remove um {entidade}
/// </summary>
/// <param name="id">ID do {entidade}</param>
/// <returns>Sem conteúdo</returns>
/// <response code="204">Remoção realizada com sucesso</response>
/// <response code="404">{Entidade} não encontrado</response>
[HttpDelete("{id:guid}")]
[ProducesResponseType(StatusCodes.Status204NoContent)]
[ProducesResponseType(StatusCodes.Status404NotFound)]
public async Task<IActionResult> Delete(Guid id)
{
    var exists = await _service.ExistsAsync(id);
    if (!exists)
    {
        _logger.LogWarning("Tentativa de remover {Entidade} inexistente: {Id}", id);
        return NotFound(new { message = $"{Entidade} não encontrado" });
    }
    
    await _service.DeleteAsync(id);
    
    _logger.LogInformation("{Entidade} {Id} removido com sucesso", id);
    
    return NoContent();
}
```

## Status Codes HTTP

| Código | Uso | Descrição |
|--------|-----|-----------|
| 200 | GET | Sucesso com retorno de dados |
| 201 | POST | Recurso criado com sucesso |
| 204 | PUT/DELETE | Sucesso sem retorno de dados |
| 400 | Todos | Dados inválidos/validação falhou |
| 404 | GET/PUT/DELETE | Recurso não encontrado |
| 500 | Todos | Erro interno (tratado por middleware) |

## Validação Automática

Com `[ApiController]`, a validação é automática:
- ModelState é validado automaticamente
- Retorna 400 Bad Request se inválido
- FluentValidation integrado via DI

## Convenções de Nomenclatura

- **Controller:** `{Entidade}Controller` (singular)
- **Route:** `api/{entidade}` (plural automático ou configurar)
- **Actions:** `GetAll`, `GetById`, `Create`, `Update`, `Delete`
- **Parâmetros:** `id` (lowercase), `dto` para objetos

## Recursos Adicionais (Opcional)

### Paginação
```csharp
[HttpGet]
public async Task<ActionResult<PagedResult<{Entidade}Dto>>> GetAll(
    [FromQuery] int page = 1, 
    [FromQuery] int pageSize = 10)
{
    var result = await _service.GetPagedAsync(page, pageSize);
    return Ok(result);
}
```

### Busca/Filtro
```csharp
[HttpGet("search")]
public async Task<ActionResult<IEnumerable<{Entidade}Dto>>> Search(
    [FromQuery] string query)
{
    var results = await _service.SearchAsync(query);
    return Ok(results);
}
```

### Ações Customizadas
```csharp
[HttpPost("{id:guid}/activate")]
public async Task<IActionResult> Activate(Guid id)
{
    await _service.ActivateAsync(id);
    return NoContent();
}
```

## Checklist de Implementação

- [ ] Herdar de `ControllerBase`
- [ ] Atributos `[ApiController]` e `[Route]`
- [ ] Injeção de dependência do service e logger
- [ ] CRUD completo (GET, POST, PUT, DELETE)
- [ ] Documentação XML em todos os métodos
- [ ] ProducesResponseType para cada status code
- [ ] Logging de operações importantes
- [ ] Validação de existência antes de Update/Delete
- [ ] Retornar DTOs, nunca entidades
- [ ] Tratamento de erros (ou deixar para middleware)

## Exemplo de Input

```
Entidade: Review
Service: IReviewService
DTOs: CreateReviewDto, UpdateReviewDto, ReviewDto
```

## Exemplo de Uso

```
@workspace Use o prompt .github/prompts/code/generate-controller.prompt.md 
para criar o controller da entidade Review com endpoints CRUD completos
```

## Integração no Program.cs

Após criar o controller, não esqueça de registrar o service:
```csharp
builder.Services.AddScoped<I{Entidade}Service, {Entidade}Service>();
```

## Teste Manual

Após implementar, testar via Swagger:
1. Iniciar a API: `dotnet run`
2. Acessar: `http://localhost:5000/swagger`
3. Testar cada endpoint
4. Verificar status codes e responses

