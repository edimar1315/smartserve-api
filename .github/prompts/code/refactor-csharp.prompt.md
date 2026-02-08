# Prompt: Refatoração de Código C#

## Objetivo
Refatorar código C# existente seguindo as melhores práticas e padrões do SmartServe API.

## Contexto do Projeto
- **Framework:** ASP.NET Core 8.0+
- **Padrões:** Clean Architecture, SOLID, DRY, KISS
- **Estilo:** C# Conventions, nullable reference types habilitado
- **Performance:** Async/await, eficiência de memória

## Checklist de Refatoração

### ✅ Código Limpo
- [ ] Nomes descritivos para variáveis, métodos e classes
- [ ] Métodos pequenos (máximo 20-30 linhas)
- [ ] Uma responsabilidade por classe/método (SRP)
- [ ] Remover código comentado ou não utilizado
- [ ] Eliminar magic numbers/strings (usar constantes)

### ✅ Performance
- [ ] Usar `async/await` em operações de I/O
- [ ] Evitar múltiplas queries (N+1 problem)
- [ ] Usar `AsNoTracking()` em queries read-only
- [ ] Considerar caching quando apropriado
- [ ] Usar `StringBuilder` para concatenação em loops

### ✅ Legibilidade
- [ ] Pattern matching moderno (C# 9+)
- [ ] Expressões lambda claras
- [ ] LINQ queries legíveis
- [ ] Early returns para reduzir aninhamento
- [ ] Guard clauses no início de métodos

### ✅ Manutenibilidade
- [ ] Injeção de dependência ao invés de `new`
- [ ] Interfaces para abstração
- [ ] DTOs para transferência de dados
- [ ] Validações centralizadas (FluentValidation)
- [ ] Tratamento de exceções adequado

### ✅ Segurança
- [ ] Validação de inputs
- [ ] Proteção contra SQL Injection (usar EF Core corretamente)
- [ ] Sanitização de dados sensíveis em logs
- [ ] Validação de autenticação/autorização

## Padrões de Refatoração Comuns

### 1. Substituir Condicionais Aninhadas
**Antes:**
```csharp
if (user != null)
{
    if (user.IsActive)
    {
        if (user.Email != null)
        {
            // lógica
        }
    }
}
```

**Depois:**
```csharp
if (user == null || !user.IsActive || user.Email == null)
    return;

// lógica
```

### 2. Extrair Métodos
**Antes:**
```csharp
public async Task<IActionResult> CreateUser(CreateUserDto dto)
{
    // 50 linhas de lógica complexa
}
```

**Depois:**
```csharp
public async Task<IActionResult> CreateUser(CreateUserDto dto)
{
    var user = MapToEntity(dto);
    await ValidateBusinessRules(user);
    await _repository.AddAsync(user);
    return CreatedAtAction(nameof(GetUser), new { id = user.Id }, user);
}
```

### 3. Usar Pattern Matching
**Antes:**
```csharp
if (result.GetType() == typeof(SuccessResult))
{
    var success = (SuccessResult)result;
    // usar success
}
```

**Depois:**
```csharp
if (result is SuccessResult success)
{
    // usar success
}
```

### 4. Substituir Switch por Dictionary/Strategy
**Antes:**
```csharp
switch (paymentMethod)
{
    case "credit": return ProcessCredit();
    case "debit": return ProcessDebit();
    case "pix": return ProcessPix();
}
```

**Depois:**
```csharp
private readonly Dictionary<string, Func<Payment>> _processors = new()
{
    ["credit"] = ProcessCredit,
    ["debit"] = ProcessDebit,
    ["pix"] = ProcessPix
};

return _processors[paymentMethod]();
```

### 5. Null Coalescing e Propagation
**Antes:**
```csharp
string name;
if (user != null && user.Profile != null)
    name = user.Profile.Name;
else
    name = "Unknown";
```

**Depois:**
```csharp
var name = user?.Profile?.Name ?? "Unknown";
```

## Áreas de Foco por Camada

### Domain (Entidades)
- Encapsulamento adequado
- Validações de domínio
- Comportamentos de negócio na entidade
- Evitar anemic domain model

### Application (Services)
- Métodos com responsabilidade única
- Tratamento de exceções
- Mapeamento entre entidades e DTOs
- Lógica de negócio centralizada

### Infrastructure (Repositórios)
- Queries otimizadas
- Uso correto de tracking
- Includes explícitos para relacionamentos
- Paginação quando aplicável

### API (Controllers)
- Controllers enxutos
- Delegação para services
- Validação automática
- Status codes corretos

## Code Smells a Identificar

1. **God Class** - Classe com muitas responsabilidades
2. **Long Method** - Métodos muito longos
3. **Duplicate Code** - Código repetido
4. **Magic Numbers** - Números sem contexto
5. **Feature Envy** - Método usa mais dados de outra classe
6. **Data Clumps** - Grupos de dados sempre juntos
7. **Primitive Obsession** - Uso excessivo de tipos primitivos

## Exemplo de Uso

```
@workspace Use o prompt .github/prompts/code/refactor-csharp.prompt.md 
para refatorar o arquivo SmartServe.Api/Application/Services/ProfessionalService.cs
focando em performance e legibilidade
```

## Ferramentas Úteis

- **ReSharper/Rider** - Refatorações automáticas
- **SonarLint** - Análise de código em tempo real
- **Code Metrics** - Complexidade ciclomática
- **dotnet format** - Formatação consistente

## Após a Refatoração

1. ✅ Executar testes unitários
2. ✅ Verificar performance (benchmarks se crítico)
3. ✅ Code review
4. ✅ Atualizar documentação se necessário
5. ✅ Commit com mensagem descritiva

