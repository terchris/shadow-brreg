# 2-download-all-brreg.sh
# Download all data from Brønnøysundregistrene into the local directory /data
# doc is here: https://data.brreg.no/enhetsregisteret/api/docs/index.html#enheter-lastned
# Usage: 2-download-all-brreg.sh 
cd ../data
curl 'https://data.brreg.no/enhetsregisteret/api/enheter/lastned/regneark' -X GET \
    -H 'Accept: application/vnd.brreg.enhetsregisteret.enhet+vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=UTF-8' -J -O



or 
wget --header='Accept: application/vnd.brreg.enhetsregisteret.enhet+vnd.openxmlformats-officedocument.spreadsheetml.sheet;charset=UTF-8' -O enheter_alle.xlsx 'https://data.brreg.no/enhetsregisteret/api/enheter/lastned/regneark'

# to keep track of the date of the last downloaded file wo touch a file named "lastdownloaded-alle"
touch lastdownloaded-alle

# we need to convert the file to csv format in order to import it
# we use libreoffice to do this. The result is  enheter_alle.csv
soffice --headless --convert-to csv:"Text - txt - csv (StarCalc)":44,34,76 enheter_alle.xlsx


# on te mac the path to soffice is /Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to csv:"Text - txt - csv (StarCalc)":44,34,76 enheter_alle.xlsx

