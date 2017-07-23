#!/bin/sh

usage()
{
  echo "Usage: zipcode.sh

    -c	  CITY	  Which city to search
    -f	  FORMAT  Which format (text, csv)
    -s	  STATE   Which state to search (Indiana)

If no CITY is specified, then all the zip codes for the STATE are displayed."
  exit 1
}

if [ "$1" == "-h" ]; then
  usage
fi

STATE="Indiana"
CITY=""
FORM="text"
while [ "$#" != 0 ];
do
  if [ "$1" == "-s" ]; then
    STATE="$2"
  elif [ "$1" == "-c" ]; then
    CITY="$2"
  elif [ "$1" == "-f" ]; then
    FORM="$2"
  fi
  shift
done

download()
{
  curl -s http://www.zipcodestogo.com/"$STATE"/
}

findCity="/"$CITY"/"

getCity()
{
  grep "$findCity"
}

getZipCode()
{
  cut -d '/' -f 6 | sed -E '/[^0-9]|^$/d'
}

printZip()
{
  if [ "$FORM" == "text" ]; then
    download | cat | getCity | getZipCode
  elif [ "$FORM" == "csv" ]; then  
    download | cat | getCity | getZipCode | paste -d , -s
  fi
}

printZip
