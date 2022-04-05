#!/bin/bash -ue

if [[ ${#} != 2 ]]; then
    echo "Wrong number of arguments"
    exit 2
fi

DIR=${1}
FILE=${2}

if [[ ! -d ${DIR} ]]; then
    echo "Directory does not exist"
    exit 1
fi

find "${DIR}" -type l ! -exec test -e {} \; -print | while read -r i; do
    rm "${i}"
    echo "$(echo "${i##*/}" | tr "[:upper:]" "[:lower:]") $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "${FILE}"
done

exit 0