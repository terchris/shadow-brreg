# a-download-changes-brreg
# Download all changes from a defined date
# doc is here: https://data.brreg.no/enhetsregisteret/api/docs/index.html#enheter-lastned
# Usage: a-download-changes-brreg.sh 

# Find the date of the last downloaded file we look at two files:
# 1. lastdownloaded-endringer
# 2. lastdownloaded-alle

# If the file lastdownloaded-endringer exist we use the date of the lastdownloaded-endringer file
# If the file lastdownloaded-endringer does not exist we use the date of the lastdownloaded-alle file


# the following code picks the date of the last downloaded file, subtracts one day and set the time to one minute to midnight 
cd ../data 
file1="lastdownloaded-endringer"
file2="lastdownloaded-alle"

if [ -f "$file1" ]; then
    timestamp=$(stat -f "%m" $file1)
else
    timestamp=$(stat -f "%m" $file2)
fi

day_before=$(date -r $timestamp +'%Y-%m-%d')
yesterday_year=${day_before:0:4}
yesterday_month=${day_before:5:2}
yesterday_day=$(printf %02d $((10#${day_before:8:2}-1)))
day_before="$yesterday_year-$yesterday_month-$yesterday_day"
date="$day_before""T23:59:59.000Z"
echo "The date of the last downloaded file is: $date"

# Download all changes from the day before the last downloaded file
#curl 'https://data.brreg.no/enhetsregisteret/api/oppdateringer/enheter?dato=$date' -i -X GET


curl 'https://data.brreg.no/enhetsregisteret/api/oppdateringer/enheter?dato=2023-01-12T23:59:59.000Z' -i -X GET
