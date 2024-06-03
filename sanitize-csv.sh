#!/bin/zsh

# This script sanitizes a semicolon delimited CSV file that may contain multiple semicolons inside a double quoted field that may contain newlines.
#
# EXAMPLE:
## cat trouble
#1; 2; 3; 4; 5; 6;
#This; may; "wreck
#     havoc; everything;
#    kaputt;"; today; "and after
#as is"; whatever;
#
#"One"; "Two"; "Three"; "Four"; "Five"; "Six";
#One;Two;Three;Four;Five;Six
#
## ./sanitize-csv.sh ./trouble
#1; 2; 3; 4; 5; 6;
#This; may; "wreck,     havoc, everything,,    kaputt,"; today; "and after,as is"; whatever;
#
#"One"; "Two"; "Three"; "Four"; "Five"; "Six";
#One;Two;Three;Four;Five;Six



if [ "$#" -ne 1 ]; then
	echo "Missing filename to work on. Aborted" >&2
	exit 1
fi

if [ ! -r "$1" ]; then
	echo "Cannot read $1. Aborted" >&2
	exit 1
fi

#cat "$1" | tr '\n' '|' | awk 'BEGIN { RS="#@%"; FS="\""; OFS="\"" } { for(i=1;i<=NF;i++) if(i%2 == 0) { gsub(/;/, ",", $i); gsub(/\n/, ",", $i); } print }' | LANG=C sed -e 's/[\d128-\d255]//g' | sed 's/;|/\n/g'
cat "$1" | awk 'BEGIN { RS="#@%"; FS="\""; OFS="\"" } { for(i=1;i<=NF;i++) if(i%2 == 0) { gsub(/;/, ",", $i); gsub(/\n/, ",", $i); } print }' | LANG=C sed -e 's/[\d128-\d255]//g' 
