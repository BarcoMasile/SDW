#!/bin/bash

set -e

SESS="split_downloads"

COMMAND="youtube-dl"

TRUE_FILE="$HOME/${SESS}_true"

if [ "$1" = "" ] || [ "$1" = "y" ]; then

	COMMAND="youtube-dl"

elif [ "$1" = "a" ]; then
	
	COMMAND="aria2c"

elif [ "$1" = "m" ]; then

	COMMAND="youtube-dl -f 140"

fi


# se gia' esiste la sessione
tmux ls 2> /dev/null | ruby -n -e 'puts $_.chomp.split(":").first' | while read line
do
	if [ "$line" = 'split_downloads' ]; then
		echo "ciao" > "$TRUE_FILE"
	fi
done


# inizia la sessione
if ! [ -e $TRUE_FILE ]; then
	tmux new -d -s "$SESS" 'echo "Attesa 5 secondi..." && sleep 3'
	echo -e "Sessione: $(ruby -r colorize -e "puts \"$SESS\".light_yellow"), iniziata"
fi


while read line; do
	if [ -e $TRUE_FILE ] ; then echo "finestra" >> "$TRUE_FILE" ; fi
	_COMMAND=$(echo "$line" | ruby -n -e '($_[/^magnet/]) ? (puts "aria2c") : (puts "youtube-dl")' )
	tmux new-window -t $SESS "$_COMMAND '$line'"

done


if [ -e $TRUE_FILE ]; then
	n="$[$(cat $TRUE_FILE | wc -l) - 1]"
	echo -e "Aggiunte $(ruby -r 'colorize' -e "puts \"$n\".light_yellow") finestre."
fi

rm "$TRUE_FILE" &> /dev/null


exit 0

