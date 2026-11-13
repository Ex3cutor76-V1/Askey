#!/usr/bin/env bash

# Variáveis
FLAG=$1
shift
palavra="$*"
codificar=$(echo -n "$palavra" | od -An -tu1)

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
echo
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
-e, --help      Ajuda
-v, --version   Versão

Modo verboso
-ve, --verbose-encode  Modo verboso na codificação
-vd, --verbose-decode  Modo verboso na decodificação

Codificação
-e, --encode     Codificar frase
-d, --decode     Decodificar frase

EOF
;;

-v|--version)
echo "Askey"
echo "Versão: 1.2"
;;

-ve|--verbose-encode)
echo "$palavra ---> $codificar"
;;

-vd|--verbose-decode)
printf 'Palavra: %s\n' "$palavra"
printf 'Palavra decodificada: '
decode "$palavra"
;;

*)
echo "Flag inválida, use askey -h ou askey --help"
;;

esac
