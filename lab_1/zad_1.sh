#!/bin/bash

# Pobranie 3 argumentów oraz przypisanie wartości domyślnych
SOURCE_DIR=${1:-"lab_uno"}
RM_LIST=${2:-"2remove"}
TARGET_DIR=${3:-"bakap"}

# Sprawdzenie czy taki plik istnieje oraz czy jest katalogiem
if [[ ! -e $TARGET_DIR ]]; then
	echo "Directory $TARGET_DIR does not exist and will be created"
	mkdir $TARGET_DIR
elif [[ ! -d $TARGET_DIR ]]; then
	echo "$TARGET_DIR exists but it's not a directory, remove it"
	exit 1
fi

# iteracja po zawartości pliku RM_LIST
if [[ ! -e $RM_LIST ]]; then
	echo "$RM_LIST does not exist"
	exit 1
fi
cat $RM_LIST | while read line; do
	if [[ -e $SOURCE_DIR/$line ]]; then
		rm $SOURCE_DIR/$line
	fi
done

# jeżeli pliku nie ma na liście ale jest plikiem regularnym to przenieś do TARGET_DIR
for file in $SOURCE_DIR/*; do
	if [[ -f $file ]]; then
		mv $file $TARGET_DIR/
	# jeżeli jest katalogiem to skopiuj wraz zawartościa do TARGET_DIR
	elif [[ -d $file ]]; then
		cp -R $file $TARGET_DIR
	fi
done

# sprawdzenie ile plików pozostało
FILES_COUNT=$(find $SOURCE_DIR/* 2> /dev/null | wc -l)
if [[ $FILES_COUNT -gt 4 ]]; then
	echo "Zostało więcej niż 4 pliki"
elif [[ $FILES_COUNT -ge 2 ]]; then
	echo "Zostały conajmniej 2 pliki"
elif [[ $FILES_COUNT -gt 0 ]]; then
	echo "Jeszcze coś zostało"
else
	echo "Tu był Kononowicz"
fi

# spakowanie katalogu TARGET_DIR
FILENAME=$(echo "bakap_`date -u +"%Y-%m-%d"`.zip")
zip -r $FILENAME $TARGET_DIR

exit 0

