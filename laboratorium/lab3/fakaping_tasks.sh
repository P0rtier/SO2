#!/bin/bash -eu

# Format fakaping.sh jest windowsowy.
dos2unix fakaping.sh

# wszystkie linijki majace zakonczenie .conf zachowaj. Wypisz na erkan i do pliku find_results.log. Odfiltruj bledy do pliku errors.log.
echo "=================== Zadanie 1 ========================="
./fakaping.sh 2> errors.log | tee -a find_results.log | grep ".conf"

# wszystkie unikalne linijki z fakaping.sh zapisz do pliku all.log i na konsole
echo "=================== Zadanie 2 ========================="
./fakaping.sh 2>&1 | sort | uniq -u | tee all.log