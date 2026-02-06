# 🚀 GitHub Push Scripts - Guia de Uso

## 📋 O que são esses scripts?

Três scripts para automatizar o processo de criar o repositório no GitHub e fazer push:

1. **push-to-github.ps1** - PowerShell (Windows) - Recomendado
2. **push-to-github.bat** - Batch (Windows) - Simples
3. **push-to-github.sh** - Bash (Linux/Mac)

---

## 🖥️ WINDOWS - Usando PowerShell (Recomendado)

### Passo 1: Permitir execução de scripts

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Passo 2: Executar o script

```powershell
cd C:\Users\edima\OneDrive\smartserve\smartserve-api
.\push-to-github.ps1
```

### O que o script faz:

1. ✅ Verifica se você está em um repositório Git
2. ✅ Verifica o status dos arquivos
3. ✅ Pede confirmação se criou o repo no GitHub
4. ✅ Configura o remote origin
5. ✅ Faz o push para o GitHub
6. ✅ Exibe a URL do repositório

---

## 🖥️ WINDOWS - Usando Batch (Simples)

### Passo 1: Executar o script

```cmd
cd C:\Users\edima\OneDrive\smartserve\smartserve-api
push-to-github.bat
```

### Funcionalidade:

- Mais simples que PowerShell
- Sem necessidade de mudar políticas de execução
- Mesma funcionalidade

---

## 🐧 LINUX / MAC - Usando Bash

### Passo 1: Dar permissão de execução

```bash
chmod +x push-to-github.sh
```

### Passo 2: Executar o script

```bash
cd ~/seu-caminho/smartserve-api
./push-to-github.sh
```

---

## 📋 PRÉ-REQUISITOS ANTES DE EXECUTAR

1. ✅ Ter criado o repositório no GitHub
   - Acesse: https://github.com/new
   - Nome: smartserve-api
   - Público: Sim
   - Clique: Create repository

2. ✅ Ter Git instalado

3. ✅ Estar dentro da pasta do projeto

---

## 🔐 AUTENTICAÇÃO NO GITHUB

### Opção 1: Token (Recomendado)

1. Acesse: https://github.com/settings/tokens
2. Clique em "Generate new token"
3. Selecione scope: `repo` (controle total de repositórios)
4. Copie o token
5. Quando o script pedir senha, cole o token

### Opção 2: Chave SSH

1. Gere a chave: `ssh-keygen -t ed25519 -C "seu-email@exemplo.com"`
2. Adicione em: https://github.com/settings/ssh/new
3. Configure Git: `git config core.sshCommand "ssh -i ~/.ssh/id_ed25519"`
4. Use URL SSH ao invés de HTTPS

### Opção 3: Senha (Menos seguro, pode não funcionar)

- GitHub desabilitou autenticação por senha em 2021
- Use Token ou SSH

---

## 🎯 FLUXO DO SCRIPT

```
1. Verifica se está em um repositório Git
   ↓
2. Verifica o status dos arquivos (sem mudanças pendentes)
   ↓
3. Pergunta se você criou o repositório no GitHub
   ↓
4. Configura o remote origin (git remote add origin ...)
   ↓
5. Faz o push para o GitHub (git push -u origin main)
   ↓
6. Exibe a URL final: https://github.com/edimar1315/smartserve-api
```

---

## ❓ TROUBLESHOOTING

### Problema: "Não está em um repositório Git"

**Solução:** Abra o terminal na pasta correta
```bash
cd C:\Users\edima\OneDrive\smartserve\smartserve-api
```

### Problema: "Erro ao fazer push"

**Possíveis causas:**
1. Repositório não foi criado no GitHub
   - Crie em: https://github.com/new

2. Autenticação falhou
   - Use Token ao invés de senha
   - Gere em: https://github.com/settings/tokens

3. URL do repositório está errada
   - Execute: `git remote -v`
   - Deve ser: `https://github.com/edimar1315/smartserve-api.git`

### Problema: Há mudanças não commitadas

**Solução:** Faça commit antes do push
```bash
git add -A
git commit -m "Sua mensagem aqui"
```

Depois execute o script novamente

### Problema: Permissão negada (PowerShell)

**Solução:** Permitir execução de scripts
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 🔄 USAR NOVAMENTE NO FUTURO

Quando você fizer mudanças e quiser enviar para o GitHub:

```bash
# 1. Commitár suas mudanças
git add -A
git commit -m "Descrição das mudanças"

# 2. Fazer push
git push origin main
```

Ou use o script novamente (se não tiver mudanças pendentes)

---

## 📚 REFERENCIAS

- **Git Docs:** https://git-scm.com/doc
- **GitHub Help:** https://docs.github.com
- **SSH Keys:** https://docs.github.com/en/authentication/connecting-to-github-with-ssh
- **Tokens:** https://github.com/settings/tokens

---

## ✨ RESUMO

Use o script apropriado para seu sistema:

| Sistema | Script | Comando |
|---------|--------|---------|
| Windows | push-to-github.ps1 | `.\push-to-github.ps1` |
| Windows (Simples) | push-to-github.bat | `push-to-github.bat` |
| Linux/Mac | push-to-github.sh | `./push-to-github.sh` |

Todos fazem a mesma coisa, escolha o que preferir! 🎉

---

**Desenvolvido com ❤️ para SmartServe Platform**

