# Prompt: Documentar API (Swagger/OpenAPI)

## Objetivo
Adicionar documentação completa de API usando Swagger/OpenAPI com XML comments e anotações.

## Contexto do Projeto
- **Framework:** ASP.NET Core 8.0+
- **Documentação:** Swashbuckle.AspNetCore
- **Formato:** OpenAPI 3.0
- **UI:** Swagger UI

## Configuração no Program.cs

```csharp
using Microsoft.OpenApi.Models;
using System.Reflection;

var builder = WebApplication.CreateBuilder(args);

// Configurar Swagger/OpenAPI
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Version = "v1",
        Title = "SmartServe API",
        Description = "API para plataforma de conexão entre clientes e profissionais",
        TermsOfService = new Uri("https://smartserve.com/terms"),
        Contact = new OpenApiContact
        {
            Name = "Suporte SmartServe",
            Email = "suporte@smartserve.com",
            Url = new Uri("https://smartserve.com/contact")
        },
        License = new OpenApiLicense
        {
            Name = "MIT License",
            Url = new Uri("https://opensource.org/licenses/MIT")
        }
    });

    // Incluir comentários XML
    var xmlFilename = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml";
    var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFilename);
    options.IncludeXmlComments(xmlPath);

    // Configurar autenticação JWT (se aplicável)
    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Description = "JWT Authorization header usando Bearer scheme. Exemplo: 'Bearer {token}'",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer"
    });

    options.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });

    // Ordenar por nome
    options.OrderActionsBy(apiDesc => apiDesc.RelativePath);
});

var app = builder.Build();

// Habilitar Swagger em Development e Production (opcional)
if (app.Environment.IsDevelopment() || app.Environment.IsProduction())
{
    app.UseSwagger();
    app.UseSwaggerUI(options =>
    {
        options.SwaggerEndpoint("/swagger/v1/swagger.json", "SmartServe API v1");
        options.RoutePrefix = "swagger"; // ou string.Empty para raiz
        options.DocumentTitle = "SmartServe API Documentation";
        
        // Temas e customizações
        options.DefaultModelsExpandDepth(-1); // Esconder models por padrão
        options.DocExpansion(Swashbuckle.AspNetCore.SwaggerUI.DocExpansion.None);
        options.EnableFilter();
        options.EnableDeepLinking();
        options.DisplayRequestDuration();
    });
}

app.Run();
```

## Habilitar XML Comments no .csproj

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
    
    <!-- Gerar documentação XML -->
    <GenerateDocumentationFile>true</GenerateDocumentationFile>
    <NoWarn>$(NoWarn);1591</NoWarn> <!-- Suprimir warnings de XML ausente -->
  </PropertyGroup>
</Project>
```

## Documentar Controllers

```csharp
using Microsoft.AspNetCore.Mvc;

namespace SmartServe.Api.Controllers;

/// <summary>
/// Controller para gerenciamento de profissionais
/// </summary>
[ApiController]
[Route("api/[controller]")]
[Produces("application/json")]
[Tags("Profissionais")]
public class ProfessionalsController : ControllerBase
{
    /// <summary>
    /// Obtém a lista de todos os profissionais
    /// </summary>
    /// <remarks>
    /// Exemplo de requisição:
    /// 
    ///     GET /api/professionals
    /// 
    /// Retorna uma lista paginada de profissionais ativos na plataforma.
    /// </remarks>
    /// <param name="page">Número da página (padrão: 1)</param>
    /// <param name="pageSize">Itens por página (padrão: 10, máximo: 100)</param>
    /// <returns>Lista de profissionais</returns>
    /// <response code="200">Lista retornada com sucesso</response>
    /// <response code="400">Parâmetros inválidos</response>
    [HttpGet]
    [ProducesResponseType(typeof(IEnumerable<ProfessionalDto>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ValidationProblemDetails), StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<IEnumerable<ProfessionalDto>>> GetAll(
        [FromQuery] int page = 1, 
        [FromQuery] int pageSize = 10)
    {
        // Implementação
    }

    /// <summary>
    /// Obtém um profissional específico por ID
    /// </summary>
    /// <param name="id">ID único do profissional</param>
    /// <returns>Dados detalhados do profissional</returns>
    /// <response code="200">Profissional encontrado</response>
    /// <response code="404">Profissional não encontrado</response>
    [HttpGet("{id:guid}")]
    [ProducesResponseType(typeof(ProfessionalDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
    public async Task<ActionResult<ProfessionalDto>> GetById(Guid id)
    {
        // Implementação
    }

    /// <summary>
    /// Cria um novo profissional
    /// </summary>
    /// <remarks>
    /// Exemplo de requisição:
    /// 
    ///     POST /api/professionals
    ///     {
    ///         "name": "João Silva",
    ///         "email": "joao@example.com",
    ///         "phone": "(11) 98765-4321",
    ///         "cpf": "123.456.789-00",
    ///         "specializationIds": ["uuid1", "uuid2"]
    ///     }
    /// 
    /// </remarks>
    /// <param name="dto">Dados para criação do profissional</param>
    /// <returns>Profissional criado</returns>
    /// <response code="201">Profissional criado com sucesso</response>
    /// <response code="400">Dados inválidos ou CPF já cadastrado</response>
    [HttpPost]
    [ProducesResponseType(typeof(ProfessionalDto), StatusCodes.Status201Created)]
    [ProducesResponseType(typeof(ValidationProblemDetails), StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<ProfessionalDto>> Create(
        [FromBody] CreateProfessionalDto dto)
    {
        // Implementação
    }

    /// <summary>
    /// Atualiza um profissional existente
    /// </summary>
    /// <param name="id">ID do profissional</param>
    /// <param name="dto">Dados para atualização</param>
    /// <returns>Sem conteúdo</returns>
    /// <response code="204">Atualização realizada com sucesso</response>
    /// <response code="400">Dados inválidos</response>
    /// <response code="404">Profissional não encontrado</response>
    [HttpPut("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(ValidationProblemDetails), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
    public async Task<IActionResult> Update(
        Guid id, 
        [FromBody] UpdateProfessionalDto dto)
    {
        // Implementação
    }

    /// <summary>
    /// Remove um profissional
    /// </summary>
    /// <param name="id">ID do profissional</param>
    /// <returns>Sem conteúdo</returns>
    /// <response code="204">Remoção realizada com sucesso</response>
    /// <response code="404">Profissional não encontrado</response>
    /// <response code="409">Profissional possui trabalhos ativos</response>
    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status409Conflict)]
    public async Task<IActionResult> Delete(Guid id)
    {
        // Implementação
    }
}
```

## Documentar DTOs

```csharp
using System.ComponentModel.DataAnnotations;

namespace SmartServe.Api.Application.DTOs;

/// <summary>
/// DTO para criação de profissional
/// </summary>
public class CreateProfessionalDto
{
    /// <summary>
    /// Nome completo do profissional
    /// </summary>
    /// <example>João Silva Santos</example>
    [Required(ErrorMessage = "Nome é obrigatório")]
    [StringLength(100, MinimumLength = 3, ErrorMessage = "Nome deve ter entre 3 e 100 caracteres")]
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// Email de contato (único na plataforma)
    /// </summary>
    /// <example>joao.silva@example.com</example>
    [Required(ErrorMessage = "Email é obrigatório")]
    [EmailAddress(ErrorMessage = "Email inválido")]
    public string Email { get; set; } = string.Empty;

    /// <summary>
    /// Telefone de contato com DDD
    /// </summary>
    /// <example>(11) 98765-4321</example>
    [Phone(ErrorMessage = "Telefone inválido")]
    public string? Phone { get; set; }

    /// <summary>
    /// CPF do profissional (formato: XXX.XXX.XXX-XX)
    /// </summary>
    /// <example>123.456.789-00</example>
    [Required(ErrorMessage = "CPF é obrigatório")]
    [RegularExpression(@"^\d{3}\.\d{3}\.\d{3}-\d{2}$", ErrorMessage = "CPF inválido")]
    public string CPF { get; set; } = string.Empty;

    /// <summary>
    /// IDs das especializações do profissional
    /// </summary>
    /// <example>["3fa85f64-5717-4562-b3fc-2c963f66afa6"]</example>
    public List<Guid> SpecializationIds { get; set; } = new();
}

/// <summary>
/// DTO de resposta com dados do profissional
/// </summary>
public class ProfessionalDto
{
    /// <summary>
    /// ID único do profissional
    /// </summary>
    public Guid Id { get; set; }

    /// <summary>
    /// Nome completo
    /// </summary>
    public string Name { get; set; } = string.Empty;

    /// <summary>
    /// Email de contato
    /// </summary>
    public string Email { get; set; } = string.Empty;

    /// <summary>
    /// Avaliação média (0-5 estrelas)
    /// </summary>
    /// <example>4.5</example>
    public decimal Rating { get; set; }

    /// <summary>
    /// Total de trabalhos concluídos
    /// </summary>
    /// <example>127</example>
    public int TotalJobs { get; set; }

    /// <summary>
    /// Indica se o profissional está ativo
    /// </summary>
    public bool IsActive { get; set; }

    /// <summary>
    /// Data de criação do perfil
    /// </summary>
    public DateTimeOffset CreatedAt { get; set; }
}
```

## Anotações Úteis

### Atributos de Documentação

| Atributo | Uso |
|----------|-----|
| `[Tags("Nome")]` | Agrupar endpoints no Swagger |
| `[Produces("application/json")]` | Tipo de resposta |
| `[Consumes("application/json")]` | Tipo de requisição |
| `[ProducesResponseType(typeof(T), StatusCode)]` | Documentar respostas |
| `[ApiExplorerSettings(IgnoreApi = true)]` | Ocultar endpoint |
| `[Obsolete("Use X")]` | Marcar como obsoleto |

### Tags XML

| Tag | Descrição |
|-----|-----------|
| `<summary>` | Descrição breve |
| `<remarks>` | Detalhes e exemplos |
| `<param name="x">` | Documentar parâmetro |
| `<returns>` | Descrever retorno |
| `<response code="200">` | Documentar status code |
| `<example>` | Exemplo de valor |
| `<exception cref="T">` | Exceções possíveis |

## Grupos e Versionamento

### Agrupar por Tags
```csharp
[Tags("Profissionais")]
public class ProfessionalsController { }

[Tags("Clientes")]
public class ClientsController { }
```

### Múltiplas Versões
```csharp
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo { Version = "v1", Title = "API v1" });
    options.SwaggerDoc("v2", new OpenApiInfo { Version = "v2", Title = "API v2" });
});

[ApiVersion("1.0")]
[Route("api/v{version:apiVersion}/[controller]")]
public class ProfessionalsController { }
```

## Checklist de Documentação

- [ ] XML comments habilitado no .csproj
- [ ] Swagger configurado no Program.cs
- [ ] Todos os controllers documentados
- [ ] DTOs com exemplos
- [ ] Status codes documentados
- [ ] Autenticação configurada (se aplicável)
- [ ] Exemplos de requisição em `<remarks>`
- [ ] Tags para agrupamento
- [ ] Versionamento (se aplicável)
- [ ] Testar no Swagger UI

## Exemplo de Uso

```
@workspace Use o prompt .github/prompts/docs/api-documentation.prompt.md 
para adicionar documentação completa de API aos controllers do projeto
```

## Acessar Documentação

Após configurar, acesse:
- **Swagger UI:** http://localhost:5000/swagger
- **JSON OpenAPI:** http://localhost:5000/swagger/v1/swagger.json

## Exportar para Postman

1. Abrir Swagger UI
2. Copiar URL do JSON: `/swagger/v1/swagger.json`
3. Postman > Import > Link > Colar URL

