#!/bin/bash -eu

if [ $# -ne 1 ]; then
  echo "Brak argumentu"
  exit 1
fi

DIR=$(cd "${1}" && pwd)

if [ ! -d "${DIR}" ]; then
  echo "${DIR} nie jest katalogiem lub nie istnieje"
  exit 1
fi

find "${DIR}" -type f -name '*.bak' -exec chmod go-w {} \;
echo "Tutaj jest oblsuga plikow .bak"

find "${DIR}" -type d -name '*.bak' -exec chmod go=rx {} \;
echo "Tutaj jest oblsuga folderow .bak"

find "${DIR}" -type d -name '*.tmp' -exec chmod o+rwx {} \;
echo "Tutaj jest oblsuga folderow .tmp"

find "${DIR}" -type f -name '*.txt' -exec chmod 241 {} \;
echo "Tutaj jest oblsuga plikow .txt"

find "${DIR}" -type f -name '*.exe' -exec chmod 755 {} \;
echo "Tutaj jest oblsuga plikow .exe"
