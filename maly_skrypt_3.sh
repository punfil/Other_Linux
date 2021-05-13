QUIT=0
NAZWAPLIKU=""
NAZWAKATALOGU=""
ROZMIARWIEKSZYNIZ=""
ROZMIARMNIEJSZYNIZ=""
ZAWARTOSC=""
WYBOR=0

while [ $QUIT -eq 0 ];
do	
	MENU1="1. Wprowadz nazwe pliku: $NAZWAPLIKU"
	MENU2="2. Wprowadz nazwe katalogu: $NAZWAKATALOGU"
	MENU3="3. Rozmiar wiekszy niz: $ROZMIARWIEKSZYNIZ"
	MENU4="4. Rozmiar mniejszy niz: $ROZMIARMNIEJSZYNIZ"
	MENU5="5. Zawartosc: $ZAWARTOSC"
	MENU6="6. Szukaj."
	MENU7="7. Koniec."
	MENU=("$MENU1" "$MENU2" "$MENU3" "$MENU4" "$MENU5" "$MENU6" "$MENU7")
	WYBOR=$(zenity --list --column="Witam w programie do szukania plikow. Wybierz opcje aby rozpoczac!" "${MENU[@]}" --height 300 --width 600)
	case "$WYBOR" in
		$MENU1)NAZWAPLIKU=$(zenity --entry --title "1. Podaj nazwe pliku:" --text "Podaj nazwe pliku: ")
	            	POLNAZWAPLIKU="-name $NAZWAPLIKU"
			if [ -z $NAZWAPLIKU ]
			then
			POLNAZWAPLIKU=""
			fi
			;;

		$MENU2) NAZWAKATALOGU=$(zenity --entry --title "2. Podaj nazwe katalogu, w ktorym jest plik:" --text "Podaj nazwe katalogu, w ktorym jest plik:")
			POLNAZWAKATALOGU="$NAZWAKATALOGU"
			if [ -z $NAZWAKATALOGU ]; then
				POLNAZWAKATALOGU="";
			fi
			;;	
		$MENU3)	ROZMIARWIEKSZYNIZ=$(zenity --scale --title "3. Podaj rozmiar wiekszy niz [MB]" --text "Podaj rozmiar wiekszy niz: [MB]" --min-value=0 --max-value=100)
			POLROZMIARWIEKSZYNIZ="-size +${ROZMIARWIEKSZYNIZ}M"
			if [ -z $ROZMIARWIEKSZYNIZ ]; then
				POLROZMIARWIEKSZYNIZ="";
			fi
			;;
		$MENU4) ROZMIARMNIEJSZYNIZ=$(zenity --scale --title "4. Podaj rozmiar mniejszy niz [MB]" --text "Podaj rozmiar mniejszy niz: [MB]" --min-value=0 --max-value=100 --value=10)
			POLROZMIARMNIEJSZYNIZ="-size -${ROZMIARMNIEJSZYNIZ}M"
			if [ -z $ROZMIARMNIEJSZYNIZ ]; then
				POLROZMIARMNIEJSZYNIZ="";
			fi
			;;
		$MENU5) ZAWARTOSC=$(zenity --entry --title "5. Podaj zawartosc pliku" --text "Podaj zawartosc:")
			POLZAWARTOSC="-exec grep -li $ZAWARTOSC {} +"
			if [ -z $ZAWARTOSC ]; then
				POLZAWARTOSC="";
			fi
			;;
		$MENU6) 
			if [ $( find $POLNAZWAKATALOGU -type f $POLNAZWAPLIKU $POLROZMIARWIEKSZYNIZ $POLROZMIARMNIEJSZYNIZ $POLZAWARTOSC | wc -l ) -gt 0 ]; then
				zenity --info --title "Wynik wyszukiwania" --text "Plik zostal odnaleziony!" --width 200
			else
				zenity --info --title "Wynik wyszukiwania" --text "Plik nie zostal odnaleziony!" --width 200

			fi
			;;
	       	$MENU7)	QUIT=1;;	
	esac
done
