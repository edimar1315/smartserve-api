# 📋 Política de Versionamento - SmartServe API

## ✅ O Que DEVE Ser Commitado

### 1. Prompts de IA (`.github/prompts/`)

**COMITAR: SIM ✅**

```
.github/prompts/
├── README.md
├── code/*.prompt.md
├── docs/*.prompt.md
├── review/*.prompt.md
└── devops/*.prompt.md
```

**Por quê?**
- São documentação técnica do projeto
- Beneficiam toda a equipe
- Evoluem com o código
- Não contêm dados sensíveis
- Facilitam onboarding
- Padrão esperado pelo GitHub Copilot

**Análogo a:** README.md, CONTRIBUTING.md, .editorconfig

### 2. Guias e Documentação

**COMITAR: SIM ✅**

```
- AI_PROMPTS_GUIDE.md
- IMPLEMENTATION_REPORT.md
- README.md
- GETTING_STARTED.md
- QUICKSTART.md
- CHECKLIST.md
```

**Por quê?**
- Documentação viva do projeto
- Referência para novos desenvolvedores
- Histórico de decisões técnicas

### 3. Configurações de Projeto

**COMITAR: SIM ✅**

```
- .editorconfig
- .github/workflows/*.yml (CI/CD)
- docker-compose.yml
- Dockerfile
- *.csproj
```

---

## ❌ O Que NÃO DEVE Ser Commitado

### 1. Arquivos de Build

**NÃO COMITAR ❌**

```
bin/
obj/
*.dll
*.exe
```

**Motivo:** Gerados automaticamente pelo build

### 2. Configurações Pessoais

**NÃO COMITAR ❌**

```
.vs/
.vscode/
.idea/
*.user
*.suo
```

**Motivo:** Específicos do IDE de cada desenvolvedor

### 3. Dados Sensíveis

**NÃO COMITAR ❌**

```
.env
.env.local
appsettings.local.json
secrets.json
```

**Motivo:** Contêm senhas, tokens, connection strings

### 4. Bancos de Dados Locais

**NÃO COMITAR ❌**

```
*.db
*.sqlite
*.db-shm
*.db-wal
```

**Motivo:** Dados locais de desenvolvimento

### 5. Logs

**NÃO COMITAR ❌**

```
*.log
logs/
```

**Motivo:** Gerados em runtime

### 6. Conversas Privadas com IA (se houver)

**NÃO COMITAR ❌**

```
.ai-conversations/
.copilot-chat/
*.ai-history.json
```

**Motivo:** Histórico pessoal de conversas

---

## 🔍 Como Verificar Antes de Comitar

### 1. Ver Arquivos Staged

```bash
git status
```

### 2. Ver Diferenças

```bash
git diff --cached
```

### 3. Verificar Se Há Secrets

```bash
# Verificar se há secrets acidentalmente adicionados
git diff --cached | grep -i "password\|secret\|token\|apikey"
```

### 4. Usar Git Secrets (Recomendado)

```bash
# Instalar
git secrets --install

# Registrar padrões
git secrets --register-aws
git secrets --add 'password\s*=\s*["\'].*["\']'
git secrets --add 'ConnectionString\s*=\s*["\'].*["\']'
```

---

## 📝 Fluxo de Commit Seguro

### 1. Antes de Adicionar

```bash
# Ver o que será commitado
git status

# Revisar mudanças
git diff
```

### 2. Adicionar Seletivamente

```bash
# Adicionar apenas arquivos específicos
git add .github/prompts/code/generate-feature.prompt.md
git add AI_PROMPTS_GUIDE.md

# OU adicionar por pasta
git add .github/prompts/

# OU adicionar tudo (CUIDADO!)
git add .
```

### 3. Verificar Stage

```bash
# Ver o que está staged
git status

# Ver conteúdo staged
git diff --cached
```

### 4. Commitar

```bash
git commit -m "docs: Add AI prompts structure

- Add 10 professional prompts for AI-assisted development
- Add quick start guide (AI_PROMPTS_GUIDE.md)
- Add implementation report
- Update GETTING_STARTED.md with AI section
"
```

---

## ✅ Checklist Antes de Push

- [ ] `git status` - Verificar arquivos staged
- [ ] `git diff --cached` - Revisar mudanças
- [ ] Nenhum arquivo de `.env` ou `secrets.json`
- [ ] Nenhum arquivo de `bin/` ou `obj/`
- [ ] Nenhuma senha ou token em texto plano
- [ ] Mensagem de commit descritiva
- [ ] Build local passou (`dotnet build`)
- [ ] Testes passaram (`dotnet test`)

---

## 🚨 E Se Commitei Por Engano?

### Remover do Stage (Antes do Commit)

```bash
# Remover arquivo específico do stage
git reset HEAD .env

# Remover todos do stage
git reset HEAD .
```

### Desfazer Último Commit (Não Pushado)

```bash
# Manter mudanças locais
git reset --soft HEAD~1

# OU descartar mudanças (CUIDADO!)
git reset --hard HEAD~1
```

### Remover Arquivo do Histórico (Já Pushado)

```bash
# Remover arquivo do histórico completo (PERIGOSO!)
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch .env" \
  --prune-empty --tag-name-filter cat -- --all

# OU usar BFG Repo-Cleaner (mais rápido)
bfg --delete-files .env
```

**⚠️ IMPORTANTE:** Depois de limpar histórico, todos devem re-clonar o repositório!

---

## 📊 Resumo Visual

```
├── ✅ COMITAR
│   ├── .github/prompts/**/*.prompt.md
│   ├── AI_PROMPTS_GUIDE.md
│   ├── IMPLEMENTATION_REPORT.md
│   ├── README.md, *.md (docs)
│   ├── *.csproj, *.sln
│   ├── Dockerfile, docker-compose.yml
│   ├── .gitignore, .editorconfig
│   └── SmartServe.Api/**/*.cs (código fonte)
│
└── ❌ NÃO COMITAR
    ├── .env, .env.local
    ├── bin/, obj/
    ├── .vs/, .vscode/, .idea/
    ├── *.user, *.suo
    ├── *.db, *.sqlite
    ├── *.log, logs/
    └── .ai-conversations/
```

---

## 🎯 Por Que os Prompts SÃO Versionados?

### Analogia

Os prompts de IA são como:
- ✅ **README.md** - Documentação que todos precisam
- ✅ **CONTRIBUTING.md** - Guia para contribuir
- ✅ **.editorconfig** - Padrões de código
- ✅ **Makefile** - Automação de tarefas

**NÃO são como:**
- ❌ `.env` - Dados sensíveis
- ❌ `bin/` - Arquivos gerados
- ❌ `.vs/` - Configuração pessoal

### Benefícios do Versionamento

1. **Evolução Documentada**
   ```
   git log -- .github/prompts/code/generate-feature.prompt.md
   ```

2. **Code Review**
   ```
   # PR #45: Melhorar prompt de geração de features
   - Adicionar validação de CPF
   - Incluir exemplo de relacionamentos
   ```

3. **Rollback Seguro**
   ```
   git checkout main -- .github/prompts/code/generate-feature.prompt.md
   ```

4. **Branching**
   ```
   feature/new-prompts
   ├── .github/prompts/code/generate-repository.prompt.md (novo)
   └── .github/prompts/README.md (atualizado)
   ```

---

## 📚 Referências

- [GitHub: What to .gitignore](https://github.com/github/gitignore)
- [Git Secrets](https://github.com/awslabs/git-secrets)
- [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)
- [Semantic Versioning](https://semver.org/)

---

## 🎓 Treinamento para a Equipe

### Para Novos Desenvolvedores

1. Ler este documento
2. Configurar `.gitignore` local
3. Instalar `git secrets`
4. Fazer primeiro commit supervisionado

### Para Tech Leads

1. Revisar PRs quanto a dados sensíveis
2. Configurar branch protection rules
3. Habilitar secret scanning no GitHub
4. Fazer code review dos prompts

---

## 🔒 Segurança Adicional

### GitHub Secret Scanning

Habilitar no repositório:
```
Settings > Security > Secret scanning
```

### Pre-commit Hooks

Instalar:
```bash
pip install pre-commit
pre-commit install
```

Configurar `.pre-commit-config.yaml`:
```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: detect-private-key
      - id: check-added-large-files
      - id: check-merge-conflict
  
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
```

---

## ✅ Conclusão

### REGRA DE OURO

> **"Se é documentação que ajuda a equipe, COMITA.  
> Se é segredo ou gerado automaticamente, NÃO COMITA."**

### Dúvida?

Pergunte-se:
1. ❓ Este arquivo ajuda outros desenvolvedores?
2. ❓ Contém dados sensíveis?
3. ❓ É gerado automaticamente?

- Se 1=SIM e 2=NÃO e 3=NÃO → **COMITAR ✅**
- Caso contrário → **NÃO COMITAR ❌**

---

**Mantido por:** Time SmartServe  
**Última atualização:** 2026-02-08  
**Versão:** 1.0.0

💡 **Em caso de dúvida, pergunte ao Tech Lead antes de comitar!**

