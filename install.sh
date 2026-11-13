#!/usr/bin/env bash

# Variável importante
PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Askey Installer
echo "Iniciando instalação do Askey..."

# Verifica se o Askey já está instalado
if command -v askey >/dev/null 2>&1; then
echo "Askey já está instalado."
exit 0
fi

# Verifica se o od existe
if ! command -v od >/dev/null 2>&1; then
echo "od não encontrado."

# Verifica se o apt existe
if command -v apt >/dev/null 2>&1; then
echo "Instalando coreutils..."

sudo apt update &
sudo apt install -y coreutils || exit 1
else
echo "Erro: gerenciador apt não encontrado."
echo "Instale o pacote coreutils manualmente."
exit 1
fi
fi

# Instala o Askey
echo "Instalando Askey..."

sudo install -m 755 ./askey.sh /usr/local/bin/askey

if [ $? -eq 0 ]; then
echo "Askey instalado com sucesso!"
else
echo "Falha na instalação."
exit 1
fi

echo "Apagando a pasta..."
rm -rf -- "$PROJECT_DIR"
