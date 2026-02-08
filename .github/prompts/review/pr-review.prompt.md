# Prompt: Code Review de Pull Request

## Objetivo
Realizar uma revisão completa e construtiva de Pull Requests seguindo as melhores práticas do SmartServe API.

## Contexto do Projeto
- **Framework:** ASP.NET Core 8.0+
- **Arquitetura:** Clean Architecture
- **Padrões:** SOLID, DRY, KISS
- **Convenções:** C# Coding Standards

## Checklist de Code Review

### ✅ 1. Funcionalidade
- [ ] O código faz o que deveria fazer?
- [ ] As funcionalidades estão completas?
- [ ] Edge cases foram considerados?
- [ ] Não há bugs óbvios?
- [ ] Validações estão presentes?

### ✅ 2. Qualidade do Código
- [ ] Código é fácil de entender?
- [ ] Nomes de variáveis/métodos são descritivos?
- [ ] Não há código duplicado?
- [ ] Métodos têm tamanho apropriado (<30 linhas)?
- [ ] Complexidade está sob controle?
- [ ] Código segue convenções do projeto?

### ✅ 3. Arquitetura e Design
- [ ] Segue Clean Architecture?
- [ ] Responsabilidades bem definidas (SRP)?
- [ ] Dependências injetadas corretamente?
- [ ] Não há acoplamento desnecessário?
- [ ] Abstrações apropriadas?
- [ ] Padrões de design utilizados corretamente?

### ✅ 4. Performance
- [ ] Queries de banco otimizadas?
- [ ] Não há problemas N+1?
- [ ] `AsNoTracking()` em queries read-only?
- [ ] Uso apropriado de async/await?
- [ ] Sem loops desnecessários?
- [ ] Memória gerenciada eficientemente?

### ✅ 5. Segurança
- [ ] Inputs são validados?
- [ ] Sem SQL Injection (EF Core usado corretamente)?
- [ ] Dados sensíveis não expostos em logs?
- [ ] Autenticação/Autorização implementada?
- [ ] Secrets não commitados?
- [ ] CORS configurado adequadamente?

### ✅ 6. Testes
- [ ] Testes unitários incluídos?
- [ ] Coverage adequado (>80%)?
- [ ] Testes de integração quando necessário?
- [ ] Casos de sucesso e falha testados?
- [ ] Mocks utilizados apropriadamente?

### ✅ 7. Documentação
- [ ] XML comments em métodos públicos?
- [ ] README atualizado se necessário?
- [ ] Swagger documentation completa?
- [ ] Comentários explicam "porquê", não "o quê"?
- [ ] TODOs justificados ou removidos?

### ✅ 8. Error Handling
- [ ] Exceções tratadas apropriadamente?
- [ ] Mensagens de erro claras?
- [ ] Logs informativos?
- [ ] Status codes HTTP corretos?
- [ ] Não há `catch` vazios?

### ✅ 9. Database
- [ ] Migrations criadas corretamente?
- [ ] Indexes apropriados?
- [ ] Relacionamentos bem definidos?
- [ ] Constraints adequadas?
- [ ] Rollback considerado?

### ✅ 10. Git e Commits
- [ ] Mensagens de commit descritivas?
- [ ] Commits atômicos?
- [ ] Sem arquivos desnecessários (bin, obj)?
- [ ] .gitignore atualizado?
- [ ] Branch nomeada apropriadamente?

## Template de Review

### Resumo
```markdown
## Resumo da Mudança
[Descrever o que o PR faz em 2-3 frases]

## Tipo de Mudança
- [ ] 🐛 Bug fix
- [ ] ✨ Nova feature
- [ ] 🔨 Refatoração
- [ ] 📝 Documentação
- [ ] 🎨 UI/UX
- [ ] ⚡ Performance
- [ ] 🔒 Segurança
```

### Pontos Positivos
```markdown
## ✅ Pontos Positivos

1. **Arquitetura bem estruturada** - Clean Architecture seguida corretamente
2. **Testes abrangentes** - Coverage de 85%
3. **Documentação completa** - XML comments em todos os métodos públicos
```

### Problemas Encontrados

#### 🔴 Críticos (Bloqueantes)
```markdown
## 🔴 Problemas Críticos

### 1. Vulnerabilidade de SQL Injection
**Arquivo:** `Services/UserService.cs:45`
```csharp
// ❌ Problema
var query = $"SELECT * FROM Users WHERE Email = '{email}'";

// ✅ Solução
var user = await _context.Users
    .FirstOrDefaultAsync(u => u.Email == email);
```

**Por quê?** String interpolation diretamente em queries permite SQL Injection.
```

#### 🟡 Importantes (Devem ser corrigidos)
```markdown
## 🟡 Problemas Importantes

### 1. Problema N+1 em Query
**Arquivo:** `Services/ProfessionalService.cs:67`
```csharp
// ❌ Problema
var professionals = await _context.Professionals.ToListAsync();
foreach (var prof in professionals)
{
    // Lazy loading - N+1 queries
    var specs = prof.Specializations.ToList();
}

// ✅ Solução
var professionals = await _context.Professionals
    .Include(p => p.Specializations)
    .ToListAsync();
```

### 2. Método Muito Longo
**Arquivo:** `Controllers/ProposalController.cs:123`
```markdown
O método `CreateProposal` tem 85 linhas. Extrair lógica para métodos privados.
```
```

#### 🟢 Sugestões (Melhorias opcionais)
```markdown
## 🟢 Sugestões de Melhoria

### 1. Usar Pattern Matching
**Arquivo:** `Services/PaymentService.cs:34`
```csharp
// Atual
if (payment.Status == PaymentStatus.Completed)
{
    // ...
}

// Sugestão
if (payment is { Status: PaymentStatus.Completed })
{
    // ...
}
```

### 2. Extrair Magic Numbers
**Arquivo:** `Validators/ProposalValidator.cs:22`
```csharp
// Atual
RuleFor(x => x.EstimatedDays)
    .InclusiveBetween(1, 365);

// Sugestão
private const int MIN_DAYS = 1;
private const int MAX_DAYS = 365;

RuleFor(x => x.EstimatedDays)
    .InclusiveBetween(MIN_DAYS, MAX_DAYS);
```
```

### Performance
```markdown
## ⚡ Considerações de Performance

1. **AsNoTracking** - Adicionar em queries read-only no `GetAll()`
2. **Caching** - Considerar cache para lista de especializações (raramente muda)
3. **Paginação** - Implementar para endpoint `GetAll()` (pode retornar muitos dados)
```

### Testes
```markdown
## 🧪 Comentários sobre Testes

✅ **Pontos Positivos:**
- Testes unitários para todos os services
- Mocks apropriados
- Casos de sucesso e erro cobertos

⚠️ **Faltando:**
- Teste de integração para endpoint de criação
- Teste de validação de CPF inválido
- Teste de concorrência
```

### Decisão Final
```markdown
## 🎯 Decisão

### ✅ Aprovado com Mudanças Solicitadas

**Resumo:**
O PR está bem estruturado e segue os padrões do projeto. Há alguns problemas 
críticos de segurança e performance que devem ser corrigidos antes do merge.

**Ações Necessárias:**
1. Corrigir vulnerabilidade de SQL Injection (CRÍTICO)
2. Resolver problema N+1 (IMPORTANTE)
3. Adicionar testes de integração (IMPORTANTE)

**Opcional:**
- Aplicar sugestões de pattern matching
- Extrair magic numbers

**Próximos Passos:**
1. Autor implementa correções
2. Marca review como "Re-review requested"
3. Revisor valida mudanças
4. Merge após aprovação final
```

## Níveis de Feedback

### 🔴 Crítico (MUST FIX)
- Bugs que quebram funcionalidade
- Vulnerabilidades de segurança
- Problemas de performance graves
- Violações de arquitetura

### 🟡 Importante (SHOULD FIX)
- Code smells
- Falta de testes importantes
- Problemas de manutenibilidade
- Inconsistências com padrões

### 🟢 Sugestão (NICE TO HAVE)
- Otimizações
- Melhorias de legibilidade
- Convenções de estilo
- Alternativas de implementação

### 💡 Pergunta (CLARIFICATION)
- Decisões de design
- Lógica não clara
- Alternativas consideradas

## Tom do Feedback

### ✅ Construtivo
```markdown
**Sugestão:** Que tal extrair esse método para facilitar testes unitários?

**Pergunta:** Considerou usar AutoMapper aqui? Pode simplificar o código.

**Alternativa:** Outra abordagem seria usar pattern matching:
[código exemplo]
```

### ❌ Evitar
```markdown
"Esse código está horrível"
"Por que você fez assim?"
"Isso está completamente errado"
"Você não sabe programar?"
```

## Ferramentas de Análise

Antes de revisar manualmente, executar:

```bash
# Análise estática
dotnet build

# Testes
dotnet test

# Code coverage
dotnet test /p:CollectCoverage=true

# Code metrics
dotnet-counters

# Security scan
dotnet list package --vulnerable
```

## Exemplo de Uso

```
@workspace Use o prompt .github/prompts/review/pr-review.prompt.md 
para revisar o Pull Request #123 que adiciona o módulo de pagamentos
```

## Checklist Final

- [ ] Todas as seções do checklist revisadas
- [ ] Problemas categorizados por severidade
- [ ] Exemplos de código fornecidos
- [ ] Sugestões são construtivas
- [ ] Decisão clara (Aprovar/Solicitar Mudanças/Rejeitar)
- [ ] Próximos passos definidos
- [ ] Tom respeitoso e profissional

## Referências

- [Microsoft C# Coding Conventions](https://docs.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions)
- [Clean Code Principles](https://github.com/dotnet/docs/blob/main/docs/csharp/fundamentals/coding-style/coding-conventions.md)
- [OWASP Security Guidelines](https://owasp.org/)

