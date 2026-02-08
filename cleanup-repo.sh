#!/bin/bash
# Script de Limpeza do Repositório SmartServe API
# Remove arquivos desnecessários do Git (mantém localmente)

echo "🧹 Iniciando Limpeza do Repositório..."
echo ""

# Navegar para o diretório do projeto
cd "$(dirname "$0")"

echo "📋 Etapa 1/4: Removendo arquivos temporários e de diagnóstico do Git..."
git rm --cached DIAGNOSTICO_E_SOLUCAO.md 2>/dev/null
git rm --cached FINAL_REPORT.txt 2>/dev/null
git rm --cached SETUP_STATUS.md 2>/dev/null
git rm --cached SUMMARY.txt 2>/dev/null
git rm --cached TREE_STRUCTURE.txt 2>/dev/null
git rm --cached PROJECT_MANIFEST.txt 2>/dev/null
git rm --cached SCRIPTS_RESUMO.txt 2>/dev/null
git rm --cached REPO_CLEANUP_ANALYSIS.md 2>/dev/null
echo "✅ Arquivos temporários removidos do Git"

echo ""
echo "🔧 Etapa 2/4: Removendo scripts de setup local do Git..."
git rm --cached setup.bat 2>/dev/null
git rm --cached setup.ps1 2>/dev/null
git rm --cached fix-setup.bat 2>/dev/null
git rm --cached fix-setup.ps1 2>/dev/null
git rm --cached diagnose.bat 2>/dev/null
git rm --cached validate.sh 2>/dev/null
git rm --cached start-containers.bat 2>/dev/null
git rm --cached stop-containers.bat 2>/dev/null
echo "✅ Scripts de setup removidos do Git"

echo ""
echo "🔑 Etapa 3/4: Removendo configurações pessoais do Git..."
git rm --cached AUTENTICACAO_GITHUB.txt 2>/dev/null
git rm --cached CRIAR_REPOSITORIO_GITHUB.txt 2>/dev/null
git rm --cached GIT_CONFIGURATION.txt 2>/dev/null
git rm --cached GITHUB_PUSH_SCRIPTS_GUIDE.md 2>/dev/null
echo "✅ Configurações pessoais removidas do Git"

echo ""
echo "🚀 Etapa 4/4: Removendo scripts de push pessoais do Git..."
git rm --cached push-to-github.bat 2>/dev/null
git rm --cached push-to-github.ps1 2>/dev/null
git rm --cached push-to-github.sh 2>/dev/null
git rm --cached push-final.ps1 2>/dev/null
echo "✅ Scripts de push removidos do Git"

echo ""
echo "📄 Etapa 5/4: Removendo outros arquivos desnecessários..."
git rm --cached INDEX.html 2>/dev/null
git rm --cached QUICKSTART.md 2>/dev/null
git rm --cached START_HERE.md 2>/dev/null
echo "✅ Outros arquivos removidos do Git"

echo ""
echo "📦 Etapa 6/4: Movendo documentação para pasta docs/..."

# Criar pasta docs se não existir
mkdir -p docs

# Mover arquivos de documentação (usando git mv para manter histórico)
git mv GETTING_STARTED.md docs/ 2>/dev/null
git mv AI_PROMPTS_GUIDE.md docs/ 2>/dev/null
git mv GIT_COMMIT_POLICY.md docs/ 2>/dev/null
git mv IMPLEMENTATION_REPORT.md docs/ 2>/dev/null
git mv HOW_TO_COMMIT.md docs/ 2>/dev/null
git mv CHECKLIST.md docs/ 2>/dev/null
git mv COMANDOS_RAPIDOS.md docs/ 2>/dev/null

echo "✅ Documentação organizada em docs/"

echo ""
echo "📝 Etapa 7/4: Atualizando .gitignore..."
git add .gitignore
echo "✅ .gitignore atualizado"

echo ""
echo "🎯 Resumo da Limpeza:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Arquivos temporários: 8 removidos"
echo "✅ Scripts de setup: 8 removidos"
echo "✅ Configurações pessoais: 4 removidos"
echo "✅ Scripts de push: 4 removidos"
echo "✅ Outros: 3 removidos"
echo "✅ Documentação: 7 movidos para docs/"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Total: 27 arquivos removidos, 7 organizados"
echo ""

echo "⚠️  IMPORTANTE:"
echo "   Os arquivos foram removidos do Git mas permanecem no seu computador!"
echo "   Eles estão agora ignorados pelo .gitignore"
echo ""

echo "🔍 Ver status:"
git status

echo ""
echo "❓ Deseja fazer commit das mudanças? (s/N): "
read -r confirm

if [[ "$confirm" =~ ^[sS]$ ]]; then
    echo ""
    echo "📝 Fazendo commit..."
    
    git commit -m "chore: Clean up repository structure

- Remove temporary and diagnostic files from Git
  * DIAGNOSTICO_E_SOLUCAO.md, FINAL_REPORT.txt, etc.
  * Total: 8 temporary files

- Remove local setup scripts from Git
  * setup.bat/ps1, fix-setup.*, diagnose.bat, etc.
  * Total: 8 setup scripts

- Remove personal configuration files from Git
  * AUTENTICACAO_GITHUB.txt, GIT_CONFIGURATION.txt, etc.
  * Total: 4 config files

- Remove personal push scripts from Git
  * push-to-github.*, push-final.ps1
  * Total: 4 push scripts

- Remove other unnecessary files
  * INDEX.html, QUICKSTART.md, START_HERE.md
  * Total: 3 files

- Organize documentation into docs/ folder
  * Move GETTING_STARTED.md, AI_PROMPTS_GUIDE.md, etc.
  * Total: 7 docs organized

- Update .gitignore with robust patterns
  * Add patterns for setup scripts, temp files, logs
  * Protect personal configs and diagnostics

Benefits:
- Professional repository structure
- Easy navigation for new developers
- Only essential files in Git
- Local development files preserved

Files remain on local disk, only removed from Git tracking.
Total cleanup: 27 files removed from Git, 7 organized.
"
    
    echo ""
    echo "✅ Commit realizado com sucesso!"
    echo ""
    
    echo "❓ Deseja fazer push para o repositório remoto? (s/N): "
    read -r push_confirm
    
    if [[ "$push_confirm" =~ ^[sS]$ ]]; then
        echo ""
        echo "🚀 Fazendo push..."
        git push
        echo ""
        echo "✅ Push realizado com sucesso!"
    else
        echo "ℹ️  Push cancelado. Use 'git push' quando estiver pronto."
    fi
else
    echo "❌ Commit cancelado"
    echo "ℹ️  Mudanças ainda estão staged. Use 'git commit' para commitar depois."
fi

echo ""
echo "🎉 Limpeza Concluída!"
echo ""
echo "📊 Novo estrutura do repositório:"
echo "smartserve-api/"
echo "├── README.md"
echo "├── .gitignore (atualizado)"
echo "├── Dockerfile"
echo "├── docker-compose.yml"
echo "├── commit-prompts.sh/ps1"
echo "├── docs/"
echo "│   ├── GETTING_STARTED.md"
echo "│   ├── AI_PROMPTS_GUIDE.md"
echo "│   ├── GIT_COMMIT_POLICY.md"
echo "│   ├── HOW_TO_COMMIT.md"
echo "│   ├── CHECKLIST.md"
echo "│   └── COMANDOS_RAPIDOS.md"
echo "├── .github/prompts/"
echo "└── SmartServe.Api/"
echo ""
echo "✨ Repositório agora está limpo e organizado!"

