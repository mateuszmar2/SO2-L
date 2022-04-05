#!/bin/bash -ue

if [[ ${#} != 1 ]]; then
    echo "Wrong number of arguments"
    exit 2
fi

DIR=${1}

if [[ ! -d ${DIR} ]]; then
    echo "Directory does not exist"
    exit 1
fi

find "${DIR}" | tail --lines +2 | while read -r i; do
    if [[ -f ${i} && ${i##*.} == "bak" ]]; then
        chmod uo-w "${i}"
    elif [[ -d ${i} && ${i##*.} == "bak" ]]; then
        chmod ug-x,o+x "${i}"
    elif [[ -d ${i} && ${i##*.} == "tmp" ]]; then
        chmod a+w "${i}"
    elif [[ -f ${i} && ${i##*.} == "txt" ]]; then
        chmod 421 "${i}"
    fi
done

exit 0