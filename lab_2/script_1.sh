#!/bin/bash -ue

make_symlink() {
    FILENAME="${1##*/}"
    ln -sf "$(readlink -f "${1}")" "${PATH2}/$(echo "${FILENAME%.*}" | tr "[:lower:]" "[:upper:]")""_ln.""${FILENAME##*.}"
}

if [[ ${#} != 2 ]]; then
    echo "Wrong number of arguments"
    exit 2
fi

PATH1=${1}
PATH2=${2}

if [[ ! -e ${PATH1} || ! -e ${PATH2} ]]; then
    echo "One of of the directories does not exist"
    exit 1
elif [[ ! -d ${PATH1} || ! -d ${PATH2} ]]; then
    echo "One of of the files is not a directory"
    exit 1
fi

find "${PATH1}" | tail --lines +2 | while read -r i; do
    if [[ -d ${i} ]]; then
        echo "${i} is a directory"
        make_symlink "${i}"
    elif [[ -h ${i} ]]; then
        echo "${i} is a symlink"
    elif [[ -f ${i} ]]; then
        echo "${i} is a regular file"
        make_symlink "${i}"
    fi
done

exit 0