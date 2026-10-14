#!/bin/bash

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Obtener la ruta del directorio actual
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Rutas de los proyectos
BACKEND_DIR="$SCRIPT_DIR/backend/inventario"
FRONTEND_DIR="$SCRIPT_DIR/proyecto sistema de inventario de abonos /inventariofront"

echo -e "${BLUE}🚀 Iniciando backend y frontend...${NC}\n"

# Verificar que los directorios existan
if [ ! -d "$BACKEND_DIR" ]; then
    echo "❌ Error: Directorio backend no encontrado en $BACKEND_DIR"
    exit 1
fi

if [ ! -d "$FRONTEND_DIR" ]; then
    echo "❌ Error: Directorio frontend no encontrado en $FRONTEND_DIR"
    exit 1
fi

# Iniciar Backend (Django)
echo -e "${GREEN}📦 Iniciando Backend (Django)...${NC}"
cd "$BACKEND_DIR"
./venv/bin/python manage.py runserver &
BACKEND_PID=$!

# Esperar un momento para que el backend se inicie
sleep 2

# Iniciar Frontend (Angular)
echo -e "${GREEN}🎨 Iniciando Frontend (Angular)...${NC}"
cd "$FRONTEND_DIR"
npm start &
FRONTEND_PID=$!

echo -e "\n${BLUE}✅ Backend y Frontend iniciados!${NC}"
echo -e "${BLUE}Backend PID: $BACKEND_PID${NC}"
echo -e "${BLUE}Frontend PID: $FRONTEND_PID${NC}"
echo -e "\n${BLUE}Backend: http://localhost:8000${NC}"
echo -e "${BLUE}Frontend: http://localhost:4200${NC}"
echo -e "\n${BLUE}Presiona Ctrl+C para detener ambos servicios${NC}\n"

# Esperar a que se presione Ctrl+C
trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; echo -e '\n${BLUE}Servicios detenidos${NC}'; exit 0" INT

wait
