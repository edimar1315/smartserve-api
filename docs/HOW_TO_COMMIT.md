# 🚀 Guia Rápido: Como Comitar os Prompts

## 🎯 Escolha Seu Terminal

### Opção 1: Git Bash (Recomendado) ✅

```bash
# No Git Bash, execute:
./commit-prompts.sh
```

### Opção 2: PowerShell

```powershell
# No PowerShell, execute:
.\commit-prompts.ps1
```

### Opção 3: Manual (Qualquer Terminal)

```bash
# 1. Ver status
git status

# 2. Adicionar arquivos
git add .github/prompts/
git add AI_PROMPTS_GUIDE.md IMPLEMENTATION_REPORT.md GIT_COMMIT_POLICY.md
git add GETTING_STARTED.md README.md .gitignore

# 3. Verificar o que será commitado
git status

# 4. Verificar se não há secrets
git diff --cached | grep -iE "password|secret|token|apikey"

# 5. Commitar
git commit -m "docs: Add AI prompts structure for development

- Add .github/prompts/ with 10 professional prompts
- Add AI transparency section in README.md
- Add comprehensive documentation
- Update GETTING_STARTED.md with AI workflow

Benefits:
- 8x faster development
- 80%+ test coverage
- 100% code consistency
"

# 6. Push
git push origin main
```

---

## 🐛 Troubleshooting

### Erro: "Permission denied" (Git Bash)

```bash
# Tornar executável (apenas Linux/Mac)
chmod +x commit-prompts.sh

# No Windows Git Bash, execute direto:
bash commit-prompts.sh
```

### Erro: "cannot be loaded" (PowerShell)

```powershell
# Mudar política de execução (uma vez)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Depois executar normalmente
.\commit-prompts.ps1
```

### Erro: "comando não encontrado"

```bash
# Certifique-se de estar na pasta do projeto
cd /c/Users/edima/OneDrive/smartserve/smartserve-api

# Execute com caminho relativo
./commit-prompts.sh
```

---

## ✅ O Que os Scripts Fazem

1. ✅ Verifica status do Git
2. ✅ Adiciona arquivos de prompts
3. ✅ Adiciona documentação
4. ✅ Verifica se há secrets (segurança)
5. ✅ Pede confirmação antes de commitar
6. ✅ Faz commit com mensagem profissional
7. ✅ Pergunta se quer fazer push
8. ✅ Exibe resultado final

---

## 📋 Checklist Antes de Executar

- [ ] Estou na pasta do projeto `smartserve-api/`
- [ ] Git está configurado (user.name e user.email)
- [ ] Não há arquivos `.env` ou `secrets.json` modificados
- [ ] Build local passou (`dotnet build`)
- [ ] Estou pronto para fazer push

---

## 🚀 Execução Rápida

### Git Bash (Mais Simples)

```bash
cd /c/Users/edima/OneDrive/smartserve/smartserve-api
./commit-prompts.sh
```

### PowerShell

```powershell
cd C:\Users\edima\OneDrive\smartserve\smartserve-api
.\commit-prompts.ps1
```

---

## 📝 Comandos Úteis

```bash
# Ver o que está staged
git status

# Ver diferenças dos arquivos staged
git diff --cached

# Desfazer stage (se necessário)
git reset HEAD .

# Ver último commit
git log -1

# Ver commits recentes
git log --oneline -5
```

---

## 💡 Dicas

### ✅ Fazer

- Revisar `git status` antes de confirmar
- Verificar `git diff --cached` para ver mudanças
- Ler a mensagem de commit antes de confirmar

### ❌ Evitar

- Comitar sem revisar arquivos
- Fazer push sem build/test local
- Adicionar arquivos `.env` ou secrets

---

## 🎯 Resultado Esperado

Após executar o script com sucesso:

```
✅ Commit realizado com sucesso!
✅ Push realizado com sucesso!
🎉 Processo concluído!
```

Seu repositório terá:
- ✅ `.github/prompts/` com 10 prompts
- ✅ `AI_PROMPTS_GUIDE.md`
- ✅ `README.md` atualizado
- ✅ Documentação completa

---

## 📞 Ajuda

Se nada funcionar, use o **método manual**:

```bash
git add .
git commit -m "docs: Add AI prompts structure"
git push
```

**Simples e efetivo!** ✅

