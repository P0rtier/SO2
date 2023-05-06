#!/bin/bash -eu

# We wszystkich plikach w katalogu groovies/ zmien $HEADERS$ na /temat/
sed -i 's#\$HEADER\$#/temat/#g' groovies/*.groovy

# We wszystkich plikach w katalogu groovies/ usuń linijki zawierające frazę 'Help docs'
sed -i '/Help docs:/d' groovies/*.groovy