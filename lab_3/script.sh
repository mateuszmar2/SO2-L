#!/bin/bash -ue

# Znajdź w pliku access_log unikalnych 10 adresów IP w access_log
grep -oE "[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+" access_log | sort -u | head -n 10

# Znajdź w pliku access_log zapytania, które mają frazę ""denied"" w linku
grep -E "[/\.]denied[/\. ]" access_log

# Znajdź w pliku access_log zapytania wysłane z IP: 64.242.88.10
grep "^64\.242\.88\.10 " access_log

# Znajdź w pliku access_log wszystkie zapytania NIEWYSŁANE z adresu IP tylko z FQDN
grep -vE "^([0-9]|\[)" access_log

# Znajdź w pliku access_log unikalne zapytania typu DELETE
grep "DELETE" access_log | sort | uniq


# Z pliku yolo.csv wypisz każdego, kto jest wart dokładnie $2.99 lub $5.99 lub $9.99. Nie wazne czy milionów, czy miliardów (tylko nazwisko i wartość). Wyniki zapisz na standardowe wyjście błędów
awk -F "," '{sub(/[BM]$/,"",$NF); print $3, $NF}' yolo.csv | grep "\$[259]\.99$" >> /dev/stderr
# Z pliku yolo.csv wypisz każdy numer IP, który w pierwszym i drugim oktecie ma po jednej cyfrze. Wyniki zapisz na standardowe wyjście błędów"
awk -F "," '{print $6}' yolo.csv | grep "^[[:digit:]]\.[[:digit:]]\." >> /dev/stderr


# We wszystkich plikach w katalogu ‘groovies’ zamień $HEADER$ na /temat/
find groovies/ -type f -exec sed -i 's/\$HEADER\$/\/temat\//g' {} \;
# We wszystkich plikach w katalogu ‘groovies’ usuń linijki zawierające frazę 'Help docs:'"
find groovies/ -type f -exec sed -i '/Help docs:/d' {} \;


# Uruchom skrypt fakaping.sh, wszystkie linijki mające zakończenie .conf zachowaj. Wypisz na ekran i do pliku find_results.log. Odfiltruj błędy do pliku: errors.log.
./fakaping.sh 2> errors.log | grep "\.conf$" | tee find_results.log
# Uruchom skrypt fakaping.sh, standardowe wyjście przekieruj do nicości, a błedy posortuj (nie usuwaj duplikatów).
./fakaping.sh > /dev/null | sort
# Uruchom skrypt fakaping.sh, wszystkie errory zawierające ""permission denied"" (bez względu na wielkośc liter) wypisz na konsolę i do pliku denied.log. Wyniki powinny być unikalne.
./fakaping.sh |& grep -i "permission denied" | sort | uniq | tee denied.log
# Uruchom skrypt fakaping.sh i wszystkie unikalne linijki zapisz do pliku all.log i na konsolę
./fakaping.sh |& sort | uniq | tee all.log

# "Zadanie dla chętnich: napisz jednolinijkowca, który klonuje (robi echo ""git clone ..."") repozytoria z ludzie.csv,
# po SSH, do katalogow imie_nazwisko (malymi literami).
# Zwróćcie uwagę, że niektóre repozytoria mają '.git' inne nie, to trzeba zunifikować! (dam za to +0.5)"
# git@github.com:nokia-wroclaw/innovativeproject-hashiplayero.git
tail -n +2 ludzie.csv | awk -F ',' -v RS='\r\n' '{sub(/ /, "_", $1); sub(/https?:\/\/github\.com\//, "git@github.com:", $3)} {printf "git clone "} /\.git$/ {printf "%s ", $3} $0 !~ /\.git$/ {printf "%s.git ", $3} {print tolower($1)}'

exit 0
