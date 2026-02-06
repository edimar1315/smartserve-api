#!/bin/bash
# Script para validar a estrutura do SmartServe API (Linux/Mac)

echo "=================================="
echo "SmartServe API - Validação"
echo "=================================="
echo ""

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Contador
PASSED=0
FAILED=0

# Função para verificar arquivo
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $1"
        ((FAILED++))
    fi
}

# Função para verificar pasta
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $1"
        ((FAILED++))
    fi
}

echo "Verificando estrutura..."
echo ""

# Verificar pastas principais
echo "📁 Pastas:"
check_dir "SmartServe.Api"
check_dir "SmartServe.Api/Domain"
check_dir "SmartServe.Api/Domain/Entities"
check_dir "SmartServe.Api/Infrastructure"
check_dir "SmartServe.Api/Infrastructure/Persistence"
check_dir "SmartServe.Api/Application"
check_dir "SmartServe.Api/Middleware"

echo ""
echo "📄 Arquivos de Configuração:"
check_file "SmartServe.Api/Program.cs"
check_file "SmartServe.Api/appsettings.json"
check_file "SmartServe.Api/SmartServe.Api.csproj"
check_file "docker-compose.yml"
check_file "Dockerfile"
check_file ".gitignore"

echo ""
echo "🗂️ Entidades:"
check_file "SmartServe.Api/Domain/Entities/User.cs"
check_file "SmartServe.Api/Domain/Entities/Professional.cs"
check_file "SmartServe.Api/Domain/Entities/Client.cs"
check_file "SmartServe.Api/Domain/Entities/Specialization.cs"
check_file "SmartServe.Api/Domain/Entities/ProfessionalSpecialization.cs"
check_file "SmartServe.Api/Domain/Entities/ServiceRequest.cs"
check_file "SmartServe.Api/Domain/Entities/Proposal.cs"
check_file "SmartServe.Api/Domain/Entities/Payment.cs"

echo ""
echo "⚙️ Infrastructure:"
check_file "SmartServe.Api/Infrastructure/Persistence/SmartServeDbContext.cs"

echo ""
echo "🔌 Middleware:"
check_file "SmartServe.Api/Middleware/ExceptionHandlingMiddleware.cs"
check_file "SmartServe.Api/Middleware/RequestLoggingMiddleware.cs"

echo ""
echo "📚 Documentação:"
check_file "README.md"
check_file "GETTING_STARTED.md"
check_file "SETUP_STATUS.md"
check_file "CHECKLIST.md"
check_file "INDEX.html"

echo ""
echo "🛠️ Scripts:"
check_file "setup.bat"
check_file "diagnose.bat"
check_file "start-containers.bat"
check_file "stop-containers.bat"

echo ""
echo "=================================="
echo "Resultado: ${GREEN}$PASSED Passou${NC} | ${RED}$FAILED Falhou${NC}"
echo "=================================="

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ Estrutura validada com sucesso!${NC}"
    exit 0
else
    echo -e "${RED}✗ Alguns arquivos estão faltando${NC}"
    exit 1
fi

