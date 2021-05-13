QUIT=0
NAZWAPLIKU=""
NAZWAKATALOGU=""
ROZMIARWIEKSZYNIZ=""
ROZMIARMNIEJSZYNIZ=""
ZAWARTOSC=""
WYBOR=0
while [ $QUIT -eq 0 ];
do
	echo "1. Wprowadz nazwe pliku: $NAZWAPLIKU"
	echo "2. Wprowadz nazwe katalogu: $NAZWAKATALOGU"
	echo "3. Rozmiar wiekszy niz [MB]: $ROZMIARWIEKSZYNIZ"
	echo "4. Rozmiar mniejszy niz [MB]: $ROZMIARMNIEJSZYNIZ"
	echo "5. Zawartosc: $ZAWARTOSC"
	echo "6. Szukaj."
	echo "7. Koniec."
	echo "Wprowadz swoj wybor. Jezeli wprowadziles cos juz wyswietla sie to przy wyborze opcji"
	read WYBOR
	case $WYBOR in
		"1") echo "Wprowadz nazwe pliku: "; 
			read NAZWAPLIKU;
			POLNAZWAPLIKU="-name $NAZWAPLIKU "
			if [ -z $NAZWAPLIKU ]; then
				POLNAZWAPLIKU="";
			fi
			;;	
		"2") echo "Wprowadz nazwe katalogu: " 
			read NAZWAKATALOGU;
			POLNAZWAKATALOGU="$NAZWAKATALOGU "
			if [ -z $NAZWAKATALOGU ]; then
				POLNAZWAKATALOGU="";
			fi
			;;	
		"3") echo "Wprowadz rozmiar wiekszy niz: "
			read ROZMIARWIEKSZYNIZ
			POLROZMIARWIEKSZYNIZ="-size +${ROZMIARWIEKSZYNIZ}M "
			if [ -z $ROZMIARWIEKSZYNIZ ]; then
				POLROZMIARWIEKSZYNIZ="";
			fi
			;;
		"4") echo "Wprowadz rozmiar mniejszy niz: "
			read ROZMIARMNIEJSZYNIZ
			POLROZMIARMNIEJSZYNIZ="-size -${ROZMIARMNIEJSZYNIZ}M "
			if [ -z $ROZMIARMNIEJSZYNIZ ]; then
				POLROZMIARMNIEJSZYNIZ="";
			fi
			;;
		"5") echo "Wprowadz zawartosc, ktora ma szukany plik: "
			read ZAWARTOSC
			POLZAWARTOSC="-exec grep -li $ZAWARTOSC {} + "
			if [ -z $ZAWARTOSC ]; then
				POLZAWARTOSC="";
			fi
			;;
		"6") echo "Szukaj!"
			WYNIK=$( find $POLNAZWAKATALOGU -type f $POLNAZWAPLIKU $POLROZMIARWIEKSZYNIZ $POLROZMIARMNIEJSZYNIZ $POLZAWARTOSC | wc -l )
			if [ $WYNIK -gt 0 ]; then
				echo "Jest taki plik";
			else
				echo "Nie ma takiego pliku";
			fi
			;;
	       	"7") echo "Koniec" && QUIT=1;;	
	esac
done

