#!/bin/bash



#Este programa tem como Objetivo mostrar a cotação das pricipais moedas e também das principais Criptomoedas.

#Moedas: USD = Dolar Americano; BRL =  Real; EUR = Euro; GBP = Libra; CNY = Yuan.
#Criptomoedas:  BTC = Bitcoin; ETH = Etherium; LTC = Litecoin; IOT = Iota.

#O programa para funcionar ele baixa o html da investing, captura todas as informações necessarias para aparecer na tela e logo em seguida ele deleta o arquivo html para não sobrecarregar a maquina do usuario. O arquivo html criado neste processo sai com o nome inserido na variavel NAME_ARQ e, caso o usuario queira mudar o nome deste arquivo basta apenas mudar o conteudo desta variavel.
#OBS: O conteudo da variavel NAME.ARQ tem que terminar com ".html", pois é a extensão do arquivo.

NAME_ARQ=CTOM.html


#Esta função serve apenas para constriur os meus cabeçalhos e rodapés
function Cabecalho () {
echo "========================================================================"
echo "                        COTAÇÃO EM TEMPO REAL                           "
echo "========================================================================"
return 0
}

#Esta função é responsavel por capturas as informações das criptomoedas e apresenta-las na tela do usuario.
function CotacaoCRM_Tela () {

        wget -O "$NAME_ARQ" https://br.investing.com/currencies/streaming-forex-rates-majors > /dev/null 2>&1

        clear

        Cabecalho

	echo -e "\n                           CRIPTOMOEDAS\n"

        local VAR
        local SIGLA
        local VENDA
        local VA
        local VR

        echo -e "                 Cambio     Venda    Var      Var% \n"

        for VAR in 945629 997650 1058255 1010798 1031068
        do
                SIGLA=$(cat "$NAME_ARQ" | tr ' ' '\n' | grep -B3 "sb_last_$VAR" | grep "^>" | sed 's/<.*//' | sed 's/>//')
                VENDA=$(cat "$NAME_ARQ" | tr ' ' '\n' | grep -m1 "sb_last_$VAR" | cut -d'>' -f2 | sed 's/<.*//')
                VA=$(cat "$NAME_ARQ" | tr ' ' '\n' | grep -m1 "sb_change_$VAR" | cut -d'>' -f2 | sed 's/<.*//')
                VR=$(cat "$NAME_ARQ" | tr ' ' '\n' | grep -m1 "sb_changepc_$VAR" | cut -d'>' -f2 | sed 's/<.*//')

                echo "                 $SIGLA    $VENDA  $VA  $VR"
        done

	echo -e "\n                         Hora Atual: $(date +%H:%M:%S) \n"

        Cabecalho

        rm "$NAME_ARQ"
        return 0

}



#Esta função é responsavel por capturas as informações da cotação das moedas e apresenta-las na tela do usuario.

#OBS: Na funçao de Cotacao_Tela é apresentado um dado na coluna "Atualização", está informação representa o último momento que aquela informação foi atualizada no site, e normalmente existe um dalay que pode variar de 10 a 15 segundos.
function Cotacao_Tela () {

	wget -O "$NAME_ARQ" https://br.investing.com/currencies/streaming-forex-rates-majors > /dev/null 2>&1
	
	clear

	Cabecalho

	local VAR
	local SIGLA
	local COMPRA
	local VENDA
	local MAX
	local MIN
	local VA
	local VR
	local UA

	echo -e "Cambio     Compra   Venda    MAX     MIN     Var      Var%  Atualização\n"

	for VAR in 2103 1 2 2111
	do
		SIGLA=$(cat "$NAME_ARQ" | tr ' ' '\n' | grep -B10 "pid-$VAR-bid" | grep "data-name" | cut -d'"' -f2)
		COMPRA=$(cat "$NAME_ARQ" | tr ' ' '\n' | grep -m1 "pid-$VAR-bid" | cut -d'>' -f2 | sed 's/<.*//')
		VENDA=$(cat "$NAME_ARQ" | tr ' ' '\n' | grep -m1 "pid-$VAR-ask" | cut -d'>' -f2 | sed 's/<.*//')
		MAX=$(cat "$NAME_ARQ" | tr ' ' '\n' | grep -m1 "pid-$VAR-high" | cut -d'>' -f2 | sed 's/<.*//')
		MIN=$(cat "$NAME_ARQ" | tr ' ' '\n' | grep -m1 "pid-$VAR-low" | cut -d'>' -f2 | sed 's/<.*//')
		VA=$(cat "$NAME_ARQ" | tr ' ' '\n' | grep -m1 "pid-$VAR-pc" | cut -d'>' -f2 | sed 's/<.*//')
		VR=$(cat "$NAME_ARQ" | tr ' ' '\n' | grep -m1 "pid-$VAR-pcp" | cut -d'>' -f2 | sed 's/<.*//')
		UA=$(cat "$NAME_ARQ" | tr ' ' '\n' | grep -A1 "pid-$VAR-time" | grep "data-value" | cut -d'>' -f2 | sed 's/<.*//')

		echo "$SIGLA    $COMPRA  $VENDA  $MAX  $MIN  $VA  $VR     $UA"
	done	

	echo -e "\n                         Hora Atual: $(date +%H:%M:%S) \n"

	Cabecalho

	rm "$NAME_ARQ"
	return 0
}


#Esta função ela é responsável por apresnetar a tela inicial do programa, ela aceita apenas duas opções (1:Câmbio Moedas e 2:Câmbio Criptomoedas), qualquer opção que seja diferente dessas duas o programa não aceitara e apresentara a mesma tela até que seja digitado uma opção valida.
function Primeira_Tela () {
	
	clear

	Cabecalho
	echo -e "\n\n\nVocê que obter informação de qual item:\n"
	echo "1) Câmbio Moedas"
	echo -e "2) Câmbio Criptomoedas \n\n\n"
	Cabecalho

	local TELA1
	read -p "Selecione uma opção: " TELA1

	if test "$TELA1" -ge 255
	then
		TELA1=255
	elif test "$TELA1" -le 0
	then
		TELA1=0
	fi
	
	case "$TELA1" in
        1)
                Cotacao_Tela
                ;;
        2)
                CotacaoCRM_Tela
                ;;
        *)
		Primeira_Tela
             ;;
	esac

	return "$TELA1"
}

# A linha abaixo representa a minha minha função "main" &:)
Primeira_Tela
