#!/bin/bash -eu

if [ $# -ne 2 ]; then
  echo "Brak argumentów!"
  exit 1
fi

DIR1=$(cd "${1}" && pwd)
DIR2=$(cd "${2}" && pwd)

if [ ! -d "${DIR1}" ]; then
  echo "${DIR1} nie jest katalogiem lub nie istnieje"
  exit 1
fi

if [ ! -d "${DIR2}" ]; then
  echo "${DIR2} nie jest katalogiem lub nie istnieje"
  exit 1
fi

echo "A oto pliki znajujace sie w ${DIR1}:"
for FILE in "${DIR1}"/*; do
  if [[ -f "${FILE}" ]]; then
    echo "Plik regularny: $FILE"
  elif [[ -d "${FILE}" ]]; then
    echo "Katalog: ${FILE}"
  elif [[ -L "${FILE}" ]]; then
    echo "Dowiązanie symboliczne: ${FILE}"
  else
    echo "Nieznany typ pliku: ${FILE}"
  fi
done

for FILE in "${DIR1}"/*; do
  if [[ -f "${FILE}" ]] || [[ -d "${FILE}" ]]; then
    FILEname=$(basename -- "${FILE}")
    extension="${FILEname##*.}"
    if [[ -n "${extension}" ]]; then
        new_FILEname=$(echo "${FILEname}_ln.${extension}" | tr '[:lower:]' '[:upper:]')
    else
        new_FILEname=$(echo "${FILEname}_ln" | tr '[:lower:]' '[:upper:]')
    fi
    ln -s "${FILE}" "${DIR2}/${new_FILEname}"
  fi
done

echo "Utworzono dowiązania symboliczne w ${DIR2}."
