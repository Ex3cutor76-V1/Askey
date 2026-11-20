#!/usr/bin/env bash

# Variáveis
FLAG=$1
shift
palavra="$*"
codificar=$(echo -n "$palavra" | od -An -tu1)
temporario=$(mktemp)

# Função de decodificação:
decode() {
for num in $*; do

# Verifica se é um número inteiro
if ! [[ "$num" =~ ^[0-9]+$ ]]; then
echo "Erro: '$num' não é um número válido." >&2
return 1
fi

# Verifica o intervalo ASCII
if (( num < 0 || num > 127 )); then
echo "Erro: '$num' está fora do intervalo ASCII." >&2
return 1
fi

printf "\\$(printf '%03o' "$num")"
done
}

decode_file() {
    local arquivo="$1"

    if [[ ! -f "$arquivo" || ! -r "$arquivo" ]]; then
        echo "Erro: arquivo inexistente ou sem permissão de leitura." >&2
        return 1
    fi

    while IFS= read -r linha || [[ -n "$linha" ]]; do
        decode "$linha" || return 1
    done < "$arquivo"
}

# Flags e suas funções
case "$FLAG" in

-e|--encode)
echo "$codificar"
;;

-d|--decode)
decode "$palavra"
;;

-h|--help)

cat << 'EOF'

Askey - A codificação de ASCII

Flags disponíveis:

suporte
-h, --help      Ajuda
-v, --version   Versão

Modo verboso
-ve, --verbose-encode  Modo verboso na codificação
-vd, --verbose-decode  Modo verboso na decodificação
-vef, --verbose-encode-file  Modo verboso de codificação de arquivos
-vdf, --verbose-decode-file  Modo verboso de decodificação de arquivos

Codificação
-ef, --encode-file   Codificar um arquivo
-df, --decode-file   Decodificar um arquivo
-e, --encode     Codificar frase
-d, --decode     Decodificar frase

EOF
;;

-v|--version)
echo "Askey"
echo "Versão: 2.0"
;;

-ve|--verbose-encode)
echo "$palavra ---> $codificar"
;;

-vd|--verbose-decode)
printf 'Palavra: %s\n' "$palavra"
printf 'Palavra decodificada: '
decode "$palavra"
;;

-ef|--encode-file)
if [ -f "$palavra" ]; then
od -An -tu1 "$palavra" > "$temporario"
mv "$temporario" "$palavra"
else
echo "Arquivo inexistente"
fi
;;

-df|--decode-file)
if [ -f "$palavra" ]; then
decode_file "$palavra" > "$temporario"
mv "$temporario" "$palavra"
else
echo "Arquivo inexistente"
fi
;;

-vef|--verbose-encode-file)
echo "Verificando se o arquivo existe..."
if [ -f "$palavra" ]; then
echo "Lendo o arquivo..."
echo "Escrevendo no temporário e alterando nome..."
od -An -tu1 "$palavra" > "$temporario"
mv "$temporario" "$palavra"
echo "Arquivo codificado!"
else
echo "Arquivo inexiste"
fi
;;

-vdf|--verbose-decode-file)
echo "Verificando se o arquivo existe..."
if [ -f "$palavra" ]; then
echo "Lendo arquivo..."
echo "Escrevendo no temporário e alterando o nome..."
decode_file "$palavra" > "$temporario"
mv "$temporario" "$palavra"
echo "Arquivo decodificado!"
else
echo "Arquivo inexiste"
fi
;;

*)
echo "Flag inválida, use askey -h ou askey --help"
;;

esac
