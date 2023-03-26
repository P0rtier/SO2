#!/bin/bash

SOURCE_DIR=${1:-lab_uno};
RM_LIST=${2:-2remove};
TARGET_DIR=${3:-bakap};

if [[ ! -d ${TARGET_DIR} ]]; then
    echo "Creating ${TARGET_DIR}";
    mkdir ${TARGET_DIR}
fi

FILES_TO_BE_REMOVED=$(cat ${RM_LIST})

for FILE in ${FILES_TO_BE_REMOVED}; do

    if [[ -f ${SOURCE_DIR}/${FILE} ]]; then
        rm -r ${SOURCE_DIR}/${FILE}
    fi

done

for ELEM in ${SOURCE_DIR}/*; do

    if [[ -f ${ELEM} ]]; then
        mv ${ELEM} ${TARGET_DIR}
    elif [[ -d ${ELEM} ]]; then
        cp -r ${ELEM} ${TARGET_DIR}
    fi

done

# Komenda sprawdza czy pliki istnieja w SOURCE_DIR, ale rowniez w 
# podfolderach
COUNT_LEFT_ELEMS=$(find ${SOURCE_DIR} -type f | wc -l);

if [[ ${COUNT_LEFT_ELEMS} -gt 0 ]]; then

    echo "jeszcze cos zostalo!";
    if [[ ${COUNT_LEFT_ELEMS} -ge 2 ]]; then

        echo "zostaly co najmniej 2 pliki";
        if [[ ${COUNT_LEFT_ELEMS} -gt 4 ]]; then

            echo "zostalo wiecej niz 4 pliki";
        else

            echo "Nie wiecej niz 4, ale co najmniej 2 sa";
        fi
    fi
else

    echo "tu byl Kononowicz";
fi

zip -r bakap_$(date +%Y-%m-%d).zip ${TARGET_DIR};

