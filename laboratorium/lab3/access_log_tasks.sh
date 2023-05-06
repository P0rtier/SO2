#!/bin/bash -eu

# 10 unikalnych adresów IP w access_log
echo "=================== Zadanie 1 ========================="
grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" access_log | sort -u | head -n 10

# unikalne zapytania typu DELETE w access_log
echo "=================== Zadanie 2 ========================="
grep "DELETE" access_log | sort | uniq

# zapytania wysłane z IP: 64.242.88.10
echo "=================== Zadanie 3 ========================="
grep "^64\.242\.88\.10.*$" access_log

# zapytania, ktore maja fraze "denied" w linku
echo "=================== Zadanie 4 ========================="
grep "\".*denied.*\"" access_log