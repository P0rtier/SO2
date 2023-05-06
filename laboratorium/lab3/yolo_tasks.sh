#!/bin/bash -eu

# rekordy, ktorych id jest liczba nieparzysta, wypisanie na standardowe wyjscie bledow
echo "=================== Zadanie 1 ========================="
cut -d',' -f1 yolo.csv | grep -E '[13579]$' | 1>&2

# imiona kazdego kto jest wart dokladnie 2.99 lub 5.99 lub 9.99 nie wazne czy M czy B
echo "=================== Zadanie 2 ========================="
cut -d ',' -f2,3,7 yolo.csv | grep -E '\$[259]\.[9]{2}[MB]' | 1>&2