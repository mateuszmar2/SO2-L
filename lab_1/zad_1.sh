#!/bin/bash

SOURCE_DIR=${1}
RM_LIST=${2}
TARGET_DIR=${3}

SOURCE_DIR=${1}
RM_LIST=${2}
TARGET_DIR=${3}


ITER=0

cat $FILENAME | while read line; do
	if [[ $((ITER % 2)) -eq 0 ]]; then
		touch "files/$line"
	else
		mkdir "files/$line"
	fi
	ITER=$((ITER + 1))
done

cat $FILENAME | while read line; do
	if [[ -d files/$line ]]; then
		echo "Katalog: $line"
	elif [[ -f files/$line ]]; then
		echo "Plik regularny: $line"
	else
		echo "Coś innego"
	fi
done

echo "`date` utworzyłem `wc zad_1_text | awk '{print $1}'` plików"
 
