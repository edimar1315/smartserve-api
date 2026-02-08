# Prompt: Gerar Testes Unitários

## Objetivo
Criar testes unitários completos e eficientes usando xUnit, Moq e FluentAssertions para o projeto SmartServe API.

## Contexto do Projeto
- **Framework de Testes:** xUnit
- **Mocking:** Moq
- **Assertions:** FluentAssertions
- **Coverage Alvo:** >80%
- **Padrão:** AAA (Arrange, Act, Assert)

## Estrutura de Projeto de Testes

```
SmartServe.Tests/
├── SmartServe.Tests.csproj
├── Unit/
│   ├── Services/
│   │   ├── ProfessionalServiceTests.cs
│   │   └── ProposalServiceTests.cs
│   ├── Validators/
│   │   └── CreateProfessionalValidatorTests.cs
│   └── Controllers/
│       └── ProfessionalsControllerTests.cs
├── Integration/
│   └── Api/
│       └── ProfessionalsIntegrationTests.cs
└── Helpers/
    ├── MockDbContext.cs
    └── TestFixtures.cs
```

## Configurar Projeto de Testes

### SmartServe.Tests.csproj
```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <IsPackable>false</IsPackable>
    <Nullable>enable</Nullable>
  </PropertyGroup>

  <ItemGroup>
    <!-- Framework de Testes -->
    <PackageReference Include="xunit" Version="2.6.6" />
    <PackageReference Include="xunit.runner.visualstudio" Version="2.5.6" />
    
    <!-- Mocking -->
    <PackageReference Include="Moq" Version="4.20.70" />
    
    <!-- Assertions Fluentes -->
    <PackageReference Include="FluentAssertions" Version="6.12.0" />
    
    <!-- Test Coverage -->
    <PackageReference Include="coverlet.collector" Version="6.0.0" />
    
    <!-- In-Memory Database -->
    <PackageReference Include="Microsoft.EntityFrameworkCore.InMemory" Version="8.0.0" />
    
    <!-- Test Server -->
    <PackageReference Include="Microsoft.AspNetCore.Mvc.Testing" Version="8.0.0" />
  </ItemGroup>

  <ItemGroup>
    <ProjectReference Include="..\SmartServe.Api\SmartServe.Api.csproj" />
  </ItemGroup>
</Project>
```

## Template de Teste de Service

```csharp
using Xunit;
using Moq;
using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SmartServe.Api.Application.Services;
using SmartServe.Api.Application.DTOs;
using SmartServe.Api.Domain.Entities;
using SmartServe.Api.Infrastructure.Persistence;

namespace SmartServe.Tests.Unit.Services;

public class ProfessionalServiceTests : IDisposable
{
    private readonly SmartServeDbContext _context;
    private readonly Mock<ILogger<ProfessionalService>> _loggerMock;
    private readonly ProfessionalService _service;

    public ProfessionalServiceTests()
    {
        // Arrange - Configuração comum
        var options = new DbContextOptionsBuilder<SmartServeDbContext>()
            .UseInMemoryDatabase(databaseName: Guid.NewGuid().ToString())
            .Options;

        _context = new SmartServeDbContext(options);
        _loggerMock = new Mock<ILogger<ProfessionalService>>();
        _service = new ProfessionalService(_context, _loggerMock.Object);

        SeedDatabase();
    }

    private void SeedDatabase()
    {
        var professionals = new List<Professional>
        {
            new Professional
            {
                Id = Guid.Parse("11111111-1111-1111-1111-111111111111"),
                Name = "João Silva",
                Email = "joao@example.com",
                Phone = "(11) 98765-4321",
                CPF = "123.456.789-00",
                IsActive = true,
                Rating = 4.5m,
                TotalJobs = 10,
                CreatedAt = DateTimeOffset.UtcNow
            },
            new Professional
            {
                Id = Guid.Parse("22222222-2222-2222-2222-222222222222"),
                Name = "Maria Santos",
                Email = "maria@example.com",
                IsActive = false,
                CreatedAt = DateTimeOffset.UtcNow
            }
        };

        _context.Professionals.AddRange(professionals);
        _context.SaveChanges();
    }

    [Fact]
    public async Task GetAllAsync_ShouldReturnAllProfessionals()
    {
        // Arrange - Já feito no construtor

        // Act
        var result = await _service.GetAllAsync();

        // Assert
        result.Should().NotBeNull();
        result.Should().HaveCount(2);
        result.Should().Contain(p => p.Name == "João Silva");
    }

    [Fact]
    public async Task GetByIdAsync_WithValidId_ShouldReturnProfessional()
    {
        // Arrange
        var id = Guid.Parse("11111111-1111-1111-1111-111111111111");

        // Act
        var result = await _service.GetByIdAsync(id);

        // Assert
        result.Should().NotBeNull();
        result!.Id.Should().Be(id);
        result.Name.Should().Be("João Silva");
        result.Email.Should().Be("joao@example.com");
    }

    [Fact]
    public async Task GetByIdAsync_WithInvalidId_ShouldReturnNull()
    {
        // Arrange
        var invalidId = Guid.NewGuid();

        // Act
        var result = await _service.GetByIdAsync(invalidId);

        // Assert
        result.Should().BeNull();
    }

    [Fact]
    public async Task CreateAsync_WithValidData_ShouldCreateProfessional()
    {
        // Arrange
        var dto = new CreateProfessionalDto
        {
            Name = "Pedro Oliveira",
            Email = "pedro@example.com",
            Phone = "(21) 91234-5678",
            CPF = "987.654.321-00"
        };

        // Act
        var result = await _service.CreateAsync(dto);

        // Assert
        result.Should().NotBeNull();
        result.Id.Should().NotBeEmpty();
        result.Name.Should().Be(dto.Name);
        result.Email.Should().Be(dto.Email);

        // Verificar se foi salvo no banco
        var saved = await _context.Professionals.FindAsync(result.Id);
        saved.Should().NotBeNull();
    }

    [Fact]
    public async Task UpdateAsync_WithValidData_ShouldUpdateProfessional()
    {
        // Arrange
        var id = Guid.Parse("11111111-1111-1111-1111-111111111111");
        var dto = new UpdateProfessionalDto
        {
            Name = "João Silva Updated",
            Phone = "(11) 99999-9999"
        };

        // Act
        await _service.UpdateAsync(id, dto);

        // Assert
        var updated = await _context.Professionals.FindAsync(id);
        updated.Should().NotBeNull();
        updated!.Name.Should().Be(dto.Name);
        updated.Phone.Should().Be(dto.Phone);
    }

    [Fact]
    public async Task UpdateAsync_WithInvalidId_ShouldThrowException()
    {
        // Arrange
        var invalidId = Guid.NewGuid();
        var dto = new UpdateProfessionalDto { Name = "Test" };

        // Act
        Func<Task> act = async () => await _service.UpdateAsync(invalidId, dto);

        // Assert
        await act.Should().ThrowAsync<KeyNotFoundException>()
            .WithMessage("*não encontrado*");
    }

    [Fact]
    public async Task DeleteAsync_WithValidId_ShouldRemoveProfessional()
    {
        // Arrange
        var id = Guid.Parse("11111111-1111-1111-1111-111111111111");

        // Act
        await _service.DeleteAsync(id);

        // Assert
        var deleted = await _context.Professionals.FindAsync(id);
        deleted.Should().BeNull();
    }

    [Fact]
    public async Task ExistsAsync_WithExistingId_ShouldReturnTrue()
    {
        // Arrange
        var id = Guid.Parse("11111111-1111-1111-1111-111111111111");

        // Act
        var result = await _service.ExistsAsync(id);

        // Assert
        result.Should().BeTrue();
    }

    [Theory]
    [InlineData("11111111-1111-1111-1111-111111111111", true)]
    [InlineData("99999999-9999-9999-9999-999999999999", false)]
    public async Task ExistsAsync_WithVariousIds_ShouldReturnExpectedResult(
        string idString, 
        bool expected)
    {
        // Arrange
        var id = Guid.Parse(idString);

        // Act
        var result = await _service.ExistsAsync(id);

        // Assert
        result.Should().Be(expected);
    }

    public void Dispose()
    {
        _context.Database.EnsureDeleted();
        _context.Dispose();
    }
}
```

## Template de Teste de Validator

```csharp
using Xunit;
using FluentAssertions;
using FluentValidation.TestHelper;
using SmartServe.Api.Application.Validators;
using SmartServe.Api.Application.DTOs;

namespace SmartServe.Tests.Unit.Validators;

public class CreateProfessionalValidatorTests
{
    private readonly CreateProfessionalValidator _validator;

    public CreateProfessionalValidatorTests()
    {
        _validator = new CreateProfessionalValidator();
    }

    [Fact]
    public void Validate_WithValidData_ShouldNotHaveErrors()
    {
        // Arrange
        var dto = new CreateProfessionalDto
        {
            Name = "João Silva",
            Email = "joao@example.com",
            Phone = "(11) 98765-4321",
            CPF = "123.456.789-00"
        };

        // Act
        var result = _validator.TestValidate(dto);

        // Assert
        result.ShouldNotHaveAnyValidationErrors();
    }

    [Theory]
    [InlineData("")]
    [InlineData("AB")]
    [InlineData(null)]
    public void Validate_WithInvalidName_ShouldHaveError(string name)
    {
        // Arrange
        var dto = new CreateProfessionalDto
        {
            Name = name,
            Email = "joao@example.com",
            CPF = "123.456.789-00"
        };

        // Act
        var result = _validator.TestValidate(dto);

        // Assert
        result.ShouldHaveValidationErrorFor(x => x.Name);
    }

    [Theory]
    [InlineData("invalid-email")]
    [InlineData("@example.com")]
    [InlineData("")]
    public void Validate_WithInvalidEmail_ShouldHaveError(string email)
    {
        // Arrange
        var dto = new CreateProfessionalDto
        {
            Name = "João Silva",
            Email = email,
            CPF = "123.456.789-00"
        };

        // Act
        var result = _validator.TestValidate(dto);

        // Assert
        result.ShouldHaveValidationErrorFor(x => x.Email);
    }

    [Theory]
    [InlineData("123.456.789-00", true)]
    [InlineData("111.111.111-11", true)]
    [InlineData("12345678900", false)]
    [InlineData("123.456.789", false)]
    [InlineData("", false)]
    public void Validate_WithVariousCPFs_ShouldValidateCorrectly(
        string cpf, 
        bool shouldBeValid)
    {
        // Arrange
        var dto = new CreateProfessionalDto
        {
            Name = "João Silva",
            Email = "joao@example.com",
            CPF = cpf
        };

        // Act
        var result = _validator.TestValidate(dto);

        // Assert
        if (shouldBeValid)
            result.ShouldNotHaveValidationErrorFor(x => x.CPF);
        else
            result.ShouldHaveValidationErrorFor(x => x.CPF);
    }
}
```

## Template de Teste de Controller

```csharp
using Xunit;
using Moq;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using SmartServe.Api.Controllers;
using SmartServe.Api.Application.Services;
using SmartServe.Api.Application.DTOs;

namespace SmartServe.Tests.Unit.Controllers;

public class ProfessionalsControllerTests
{
    private readonly Mock<IProfessionalService> _serviceMock;
    private readonly Mock<ILogger<ProfessionalsController>> _loggerMock;
    private readonly ProfessionalsController _controller;

    public ProfessionalsControllerTests()
    {
        _serviceMock = new Mock<IProfessionalService>();
        _loggerMock = new Mock<ILogger<ProfessionalsController>>();
        _controller = new ProfessionalsController(
            _serviceMock.Object, 
            _loggerMock.Object);
    }

    [Fact]
    public async Task GetAll_ShouldReturnOkWithListOfProfessionals()
    {
        // Arrange
        var professionals = new List<ProfessionalDto>
        {
            new ProfessionalDto { Id = Guid.NewGuid(), Name = "João" },
            new ProfessionalDto { Id = Guid.NewGuid(), Name = "Maria" }
        };

        _serviceMock.Setup(s => s.GetAllAsync())
            .ReturnsAsync(professionals);

        // Act
        var result = await _controller.GetAll();

        // Assert
        var okResult = result.Result.Should().BeOfType<OkObjectResult>().Subject;
        var returnedProfessionals = okResult.Value.Should()
            .BeAssignableTo<IEnumerable<ProfessionalDto>>().Subject;
        returnedProfessionals.Should().HaveCount(2);
    }

    [Fact]
    public async Task GetById_WithValidId_ShouldReturnOkWithProfessional()
    {
        // Arrange
        var id = Guid.NewGuid();
        var professional = new ProfessionalDto 
        { 
            Id = id, 
            Name = "João Silva" 
        };

        _serviceMock.Setup(s => s.GetByIdAsync(id))
            .ReturnsAsync(professional);

        // Act
        var result = await _controller.GetById(id);

        // Assert
        var okResult = result.Result.Should().BeOfType<OkObjectResult>().Subject;
        var returned = okResult.Value.Should().BeOfType<ProfessionalDto>().Subject;
        returned.Id.Should().Be(id);
    }

    [Fact]
    public async Task GetById_WithInvalidId_ShouldReturnNotFound()
    {
        // Arrange
        var id = Guid.NewGuid();
        _serviceMock.Setup(s => s.GetByIdAsync(id))
            .ReturnsAsync((ProfessionalDto?)null);

        // Act
        var result = await _controller.GetById(id);

        // Assert
        result.Result.Should().BeOfType<NotFoundObjectResult>();
    }

    [Fact]
    public async Task Create_WithValidData_ShouldReturnCreatedAtAction()
    {
        // Arrange
        var dto = new CreateProfessionalDto
        {
            Name = "João Silva",
            Email = "joao@example.com"
        };

        var created = new ProfessionalDto
        {
            Id = Guid.NewGuid(),
            Name = dto.Name,
            Email = dto.Email
        };

        _serviceMock.Setup(s => s.CreateAsync(dto))
            .ReturnsAsync(created);

        // Act
        var result = await _controller.Create(dto);

        // Assert
        var createdResult = result.Result.Should()
            .BeOfType<CreatedAtActionResult>().Subject;
        createdResult.ActionName.Should().Be(nameof(_controller.GetById));
        
        var returned = createdResult.Value.Should()
            .BeOfType<ProfessionalDto>().Subject;
        returned.Id.Should().Be(created.Id);
    }

    [Fact]
    public async Task Update_WithValidData_ShouldReturnNoContent()
    {
        // Arrange
        var id = Guid.NewGuid();
        var dto = new UpdateProfessionalDto { Name = "Updated" };

        _serviceMock.Setup(s => s.ExistsAsync(id))
            .ReturnsAsync(true);
        _serviceMock.Setup(s => s.UpdateAsync(id, dto))
            .Returns(Task.CompletedTask);

        // Act
        var result = await _controller.Update(id, dto);

        // Assert
        result.Should().BeOfType<NoContentResult>();
    }

    [Fact]
    public async Task Delete_WithExistingId_ShouldReturnNoContent()
    {
        // Arrange
        var id = Guid.NewGuid();

        _serviceMock.Setup(s => s.ExistsAsync(id))
            .ReturnsAsync(true);
        _serviceMock.Setup(s => s.DeleteAsync(id))
            .Returns(Task.CompletedTask);

        // Act
        var result = await _controller.Delete(id);

        // Assert
        result.Should().BeOfType<NoContentResult>();
    }
}
```

## Padrão AAA (Arrange-Act-Assert)

```csharp
[Fact]
public async Task NomeDoTeste_Condicao_ResultadoEsperado()
{
    // Arrange - Configurar dados e mocks
    var input = new CreateDto { Name = "Test" };
    _mockService.Setup(x => x.Create(input)).ReturnsAsync(result);

    // Act - Executar ação
    var result = await _controller.Create(input);

    // Assert - Verificar resultado
    result.Should().NotBeNull();
    result.Should().BeOfType<OkResult>();
}
```

## Boas Práticas

### ✅ Fazer
- Testar um comportamento por teste
- Nomes descritivos: `Method_Condition_Expected`
- Usar `Theory` para testes parametrizados
- Isolar testes (não depender de ordem)
- Limpar recursos com `IDisposable`
- Usar FluentAssertions para legibilidade

### ❌ Evitar
- Testes que dependem de ordem
- Testes com lógica complexa
- Múltiplos asserts não relacionados
- Testar implementação ao invés de comportamento
- Testes flaky (resultados inconsistentes)

## Executar Testes

```bash
# Todos os testes
dotnet test

# Específico por namespace
dotnet test --filter "FullyQualifiedName~SmartServe.Tests.Unit.Services"

# Com cobertura
dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover

# Verbose
dotnet test --logger "console;verbosity=detailed"
```

## Exemplo de Uso

```
@workspace Use o prompt .github/prompts/review/unit-tests.prompt.md 
para gerar testes unitários completos para o ProfessionalService
```

## Checklist

- [ ] Projeto de testes configurado
- [ ] Dependências instaladas (xUnit, Moq, FluentAssertions)
- [ ] Testes para todos os cenários de sucesso
- [ ] Testes para cenários de erro
- [ ] Testes parametrizados para múltiplos inputs
- [ ] Mocks configurados corretamente
- [ ] Assertions claras
- [ ] Coverage >80%
- [ ] Testes passando

