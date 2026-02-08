# 🤖 Prompts de IA - SmartServe API

Coleção de prompts reutilizáveis para desenvolvimento assistido por IA (GitHub Copilot, ChatGPT, etc.) no projeto SmartServe API.

## 📂 Estrutura

```
.github/prompts/
├── README.md                    # Este arquivo
├── code/                        # Geração e análise de código
│   ├── generate-feature.prompt.md
│   ├── generate-controller.prompt.md
│   ├── generate-service.prompt.md
│   └── refactor-csharp.prompt.md
├── docs/                        # Documentação
│   ├── create-readme.prompt.md
│   ├── api-documentation.prompt.md
│   └── generate-prd.prompt.md (planejado)
├── review/                      # Code review e QA
│   ├── pr-review.prompt.md
│   └── unit-tests.prompt.md
└── devops/                      # CI/CD e infraestrutura
    ├── dockerfile.prompt.md
    └── azure-pipeline.prompt.md
```

## 🎯 Como Usar

### Método 1: GitHub Copilot Chat (Recomendado)

No Rider/Visual Studio, use `Ctrl+Shift+I` e referencie o prompt:

```
@workspace Use o prompt .github/prompts/code/generate-controller.prompt.md 
para criar o controller da entidade Review com endpoints CRUD completos
```

### Método 2: Copiar e Colar

1. Abra o arquivo `.prompt.md` desejado
2. Copie o conteúdo
3. Cole no chat de IA (ChatGPT, Claude, etc.)
4. Adicione o contexto específico do seu caso

### Método 3: Incluir no Prompt Customizado

```markdown
# Meu Prompt

[Contexto específico]

Siga as instruções do arquivo: .github/prompts/code/generate-feature.prompt.md
```

## 📋 Prompts Disponíveis

### 🔧 Code Generation

#### `generate-feature.prompt.md`
Cria uma feature completa seguindo Clean Architecture.

**Use quando:** Precisar criar uma nova funcionalidade do zero

**Gera:**
- Entidade (Domain)
- DTOs (Application)
- Validators (FluentValidation)
- Service + Interface
- Controller

**Exemplo:**
```
Criar feature de Avaliações (Reviews) com:
- Rating (1-5 estrelas)
- Comment (opcional)
- ProfessionalId, ClientId
```

---

#### `generate-controller.prompt.md`
Cria um controller RESTful completo.

**Use quando:** Precisar apenas do controller (entidade e service já existem)

**Gera:**
- CRUD completo (GET, POST, PUT, DELETE)
- Documentação XML
- Status codes corretos
- Validações

---

#### `generate-service.prompt.md`
Cria service com lógica de negócio.

**Use quando:** Precisar implementar camada de serviço

**Gera:**
- Interface do serviço
- Implementação
- CRUD + métodos customizados
- Mapeamento Entity ↔ DTO

---

#### `refactor-csharp.prompt.md`
Refatora código existente seguindo boas práticas.

**Use quando:** Código precisa de melhorias de qualidade/performance

**Foca em:**
- Padrões SOLID
- Performance (N+1, AsNoTracking)
- Legibilidade
- Segurança

---

### 📝 Documentation

#### `create-readme.prompt.md`
Gera README.md completo e profissional.

**Use quando:** Iniciar novo projeto ou atualizar documentação

**Inclui:**
- Badges
- Instruções de instalação
- Documentação de API
- Troubleshooting

---

#### `api-documentation.prompt.md`
Adiciona documentação Swagger/OpenAPI completa.

**Use quando:** Endpoints precisam de documentação XML

**Configura:**
- XML comments
- ProducesResponseType
- Exemplos de requisição
- Status codes

---

### 🔍 Code Review

#### `pr-review.prompt.md`
Template completo para code review de Pull Requests.

**Use quando:** Revisar PR antes de merge

**Avalia:**
- Funcionalidade
- Qualidade do código
- Segurança
- Performance
- Testes

---

#### `unit-tests.prompt.md`
Gera testes unitários com xUnit + Moq + FluentAssertions.

**Use quando:** Precisar de testes para service/controller

**Gera:**
- Testes de sucesso
- Testes de erro
- Mocks configurados
- Assertions claras

---

### 🚀 DevOps

#### `dockerfile.prompt.md`
Otimiza Dockerfile para produção.

**Use quando:** Configurar ou melhorar containerização

**Implementa:**
- Multi-stage build
- Imagem Alpine
- Usuário não-root
- Health checks

---

#### `azure-pipeline.prompt.md`
Pipeline CI/CD completo para Azure DevOps.

**Use quando:** Configurar deploy automatizado

**Inclui:**
- Build + Test
- Security scan
- Docker build
- Deploy staging/production
- Blue-green deployment

---

## 💡 Boas Práticas

### 1. Sempre Fornecer Contexto
```
❌ "Criar um controller"
✅ "Criar controller para entidade Review com endpoints CRUD, 
    validação de rating (1-5) e relacionamento com Professional"
```

### 2. Especificar Arquivos Relevantes
```
@workspace Use o prompt X considerando:
- SmartServe.Api/Domain/Entities/Professional.cs
- SmartServe.Api/Application/DTOs/ProfessionalDto.cs
```

### 3. Iterar e Refinar
Se o resultado não ficou perfeito:
```
Agora ajuste o código para [especificar o que mudar]
```

### 4. Validar Depois
Sempre executar após a geração:
- `dotnet build` - Verificar compilação
- `dotnet test` - Executar testes
- `get_errors` - Checar erros do IDE

## 🔄 Workflow Recomendado

### Feature Completa
```
1. @workspace Use generate-feature.prompt.md para criar entidade Review
2. @workspace Use unit-tests.prompt.md para testes do ReviewService
3. @workspace Use api-documentation.prompt.md para documentar ReviewController
4. dotnet build && dotnet test
```

### Code Review
```
1. @workspace Use pr-review.prompt.md para revisar PR #123
2. Aplicar correções sugeridas
3. @workspace Use refactor-csharp.prompt.md nas partes problemáticas
```

### Deploy
```
1. @workspace Use dockerfile.prompt.md para otimizar container
2. @workspace Use azure-pipeline.prompt.md para CI/CD
3. Configurar service connections
4. Executar pipeline
```

## 🎓 Dicas Avançadas

### Combinar Múltiplos Prompts
```
@workspace Use generate-feature.prompt.md e unit-tests.prompt.md 
para criar a feature Review COM testes incluídos
```

### Ajustar para Caso Específico
```
Use generate-controller.prompt.md mas:
- Adicione endpoint GET /search com filtros
- Implemente paginação em GetAll
- Adicione autorização [Authorize(Roles = "Admin")]
```

### Gerar Variações
```
Use generate-service.prompt.md para criar:
1. ReviewService (CRUD básico)
2. ReviewAnalyticsService (agregações)
3. ReviewModerationService (validação de conteúdo)
```

## 📊 Métricas de Sucesso

Após usar os prompts, você deve ter:
- ✅ Código compilando sem erros
- ✅ Testes passando (>80% coverage)
- ✅ Documentação completa (XML + Swagger)
- ✅ Padrões do projeto seguidos
- ✅ Performance otimizada
- ✅ Segurança validada

## 🤝 Contribuindo

### Adicionar Novo Prompt

1. Criar arquivo na categoria apropriada:
   ```
   .github/prompts/[categoria]/[nome].prompt.md
   ```

2. Seguir template:
   ```markdown
   # Prompt: [Título]
   
   ## Objetivo
   [O que o prompt faz]
   
   ## Contexto do Projeto
   [Tecnologias e padrões]
   
   ## [Seções específicas]
   
   ## Exemplo de Uso
   ```

3. Atualizar este README

### Melhorar Prompt Existente

1. Testar com casos reais
2. Identificar gaps ou ambiguidades
3. Adicionar exemplos práticos
4. Atualizar documentação

## 📚 Recursos Adicionais

- [GitHub Copilot Docs](https://docs.github.com/en/copilot)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [ASP.NET Core Best Practices](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/best-practices)
- [C# Coding Conventions](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions)

## 🐛 Troubleshooting

### Prompt não funciona como esperado

1. **Verifique o contexto:** IA precisa entender a estrutura do projeto
   ```
   @workspace [descrição do que precisa]
   ```

2. **Seja mais específico:**
   ```
   ❌ "Criar service"
   ✅ "Criar ProfessionalService com métodos GetByCity, GetTopRated, UpdateRating"
   ```

3. **Forneça exemplos:**
   ```
   Similar ao ClientService.cs mas com funcionalidade X
   ```

### Código gerado tem erros

1. Use `get_errors` para ver erros específicos
2. Peça para corrigir:
   ```
   O código tem erro de compilação em [arquivo:linha]. Corrija.
   ```

### Resultado inconsistente

- ✅ Use prompts mais estruturados
- ✅ Forneça exemplos do projeto
- ✅ Itere em pequenos passos

## 📞 Suporte

- **Issues:** [GitHub Issues](https://github.com/seu-repo/issues)
- **Discussões:** [GitHub Discussions](https://github.com/seu-repo/discussions)
- **Email:** dev@smartserve.com

---

## 🏆 Prompts Planejados

### Próximas Adições
- [ ] `docs/generate-prd.prompt.md` - Product Requirements Document
- [ ] `docs/architecture-diagram.prompt.md` - Diagramas de arquitetura
- [ ] `review/security-audit.prompt.md` - Auditoria de segurança
- [ ] `review/performance-analysis.prompt.md` - Análise de performance
- [ ] `devops/kubernetes-deploy.prompt.md` - Deploy no Kubernetes
- [ ] `devops/monitoring-setup.prompt.md` - Configurar Application Insights
- [ ] `code/generate-repository.prompt.md` - Pattern Repository
- [ ] `code/generate-validator.prompt.md` - FluentValidation rules

---

**Última atualização:** 2026-02-08  
**Versão:** 1.0.0  
**Mantido por:** Time SmartServe

⭐ **Se estes prompts foram úteis, considere dar uma estrela no repositório!**

