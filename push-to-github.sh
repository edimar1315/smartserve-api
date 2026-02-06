#!/bin/bash

# Script para fazer push para GitHub
# SmartServe API - GitHub Push Automation
# Para Linux/Mac

set -e

# Cores ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

# Configuração
REPO_NAME="smartserve-api"
GITHUB_USER="edimar1315"
BRANCH="main"

echo ""
echo "╔════════════════════════════════════════════════════════════════════════════════╗"
echo "║                   SmartServe API - GitHub Push Script                         ║"
echo "╚════════════════════════════════════════════════════════════════════════════════╝"
echo ""

# Funções para mensagens
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Verificar se está em repositório Git
if [ ! -d ".git" ]; then
    error "Não está em um repositório Git!"
    echo ""
    echo "Execute este script dentro da pasta do projeto."
    exit 1
fi

success "Repositório Git encontrado"

# Verificar se git está instalado
if ! command -v git &> /dev/null; then
    error "Git não encontrado! Instale o Git."
    exit 1
fi

GIT_VERSION=$(git --version)
success "$GIT_VERSION"

echo ""
echo "═══════════════════════════════════════════════════════════════════════════════"
echo "CONFIGURAÇÃO"
echo "═══════════════════════════════════════════════════════════════════════════════"
echo ""
echo "Repositório:     $REPO_NAME"
echo "GitHub User:     $GITHUB_USER"
echo "Branch:          $BRANCH"
echo "URL:             https://github.com/$GITHUB_USER/$REPO_NAME.git"
echo ""

# Avisar sobre criação do repositório
echo "═══════════════════════════════════════════════════════════════════════════════"
warning "IMPORTANTE!"
echo "═══════════════════════════════════════════════════════════════════════════════"
echo ""
echo "Antes de continuar, você PRECISA ter criado o repositório no GitHub:"
echo ""
echo -e "${BLUE}1. Acesse:  https://github.com/new${NC}"
echo -e "${BLUE}2. Nome:    $REPO_NAME${NC}"
echo -e "${BLUE}3. Público: Sim${NC}"
echo -e "${BLUE}4. Clique:  Create repository${NC}"
echo ""

read -p "Você criou o repositório no GitHub? (sim/não): " CONFIRM

if [ "$CONFIRM" != "sim" ] && [ "$CONFIRM" != "s" ]; then
    echo ""
    warning "Crie o repositório em: https://github.com/new"
    echo ""
    echo "Depois execute este script novamente."
    exit 0
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════════════════"
echo "ETAPA 1: Verificar Status do Git Local"
echo "═══════════════════════════════════════════════════════════════════════════════"
echo ""

# Verificar status
STATUS=$(git status --short)
if [ -n "$STATUS" ]; then
    echo "Há mudanças não commitadas:"
    echo "$STATUS"
    echo ""
    warning "Execute 'git add -A' e 'git commit' antes do push"
    exit 1
else
    success "Nenhuma mudança pendente"
fi

# Verificar branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "Branch atual: $CURRENT_BRANCH"
echo ""

if [ "$CURRENT_BRANCH" != "$BRANCH" ]; then
    warning "Você está na branch '$CURRENT_BRANCH', não em '$BRANCH'"
    echo ""
    read -p "Deseja trocar para $BRANCH? (sim/não): " SWITCH_BRANCH
    if [ "$SWITCH_BRANCH" = "sim" ] || [ "$SWITCH_BRANCH" = "s" ]; then
        git switch -c $BRANCH
        success "Branch trocada para $BRANCH"
    fi
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════════════════"
echo "ETAPA 2: Configurar Remote GitHub"
echo "═══════════════════════════════════════════════════════════════════════════════"
echo ""

# Verificar remote
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")

if [ -n "$REMOTE_URL" ]; then
    echo "Remote 'origin' já configurado:"
    echo "  $REMOTE_URL"
    echo ""
    read -p "Deseja manter? (sim/não): " CHANGE_REMOTE
    if [ "$CHANGE_REMOTE" != "sim" ] && [ "$CHANGE_REMOTE" != "s" ]; then
        echo "Removendo remote antigo..."
        git remote remove origin
        success "Remote removido"
    fi
else
    info "Remote 'origin' não configurado ainda"
fi

# Adicionar remote se necessário
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
if [ -z "$REMOTE_URL" ]; then
    REPO_URL="https://github.com/$GITHUB_USER/$REPO_NAME.git"
    echo "Adicionando remote: $REPO_URL"
    git remote add origin $REPO_URL
    success "Remote 'origin' adicionado"
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════════════════"
echo "ETAPA 3: Fazer Push para GitHub"
echo "═══════════════════════════════════════════════════════════════════════════════"
echo ""

warning "Aguardando autenticação GitHub..."
echo ""
echo "Se usar Token (recomendado):"
echo -e "${BLUE}  - URL: https://github.com/settings/tokens${NC}"
echo -e "${BLUE}  - Scope: repo (controle total de repositórios)${NC}"
echo ""

echo "Enviando para GitHub..."
git push -u origin $BRANCH

if [ $? -eq 0 ]; then
    echo ""
    echo "═══════════════════════════════════════════════════════════════════════════════"
    success "SUCESSO!"
    echo "═══════════════════════════════════════════════════════════════════════════════"
    echo ""
    echo -e "${GREEN}Seu repositório está disponível em:${NC}"
    echo -e "${BLUE}  https://github.com/$GITHUB_USER/$REPO_NAME${NC}"
    echo ""
    echo "Próximos passos:"
    echo -e "${BLUE}  1. Abra o link acima${NC}"
    echo -e "${BLUE}  2. Verifique se todos os 21+ arquivos estão lá${NC}"
    echo -e "${BLUE}  3. Configure Settings > Collaborators se quiser adicionar pessoas${NC}"
    echo ""
else
    echo ""
    echo "═══════════════════════════════════════════════════════════════════════════════"
    error "ERRO ao fazer push!"
    echo "═══════════════════════════════════════════════════════════════════════════════"
    echo ""
    echo "Verifique:"
    echo -e "${BLUE}  1. Repositório existe no GitHub${NC}"
    echo -e "${BLUE}  2. Autenticação está correta${NC}"
    echo -e "${BLUE}  3. URL do repositório está correta${NC}"
    echo ""
    echo "Execute novamente com:"
    echo -e "${BLUE}  ./push-to-github.sh${NC}"
    exit 1
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════════════════"
echo "Script finalizado"
echo "═══════════════════════════════════════════════════════════════════════════════"
echo ""

