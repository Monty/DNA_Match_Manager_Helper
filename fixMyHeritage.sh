#!/usr/bin/env bash

# Fix My Heritage downloaded file

# 1  DNA Match ID; 2  Name; 3  Age; 4  Country; 5  Contact DNA Match
# 6  DNA managed by; 7  Contact DNA Manager; 8  Status; 9  Estimated relationship
# 10  Total cM shared; 11  Percent DNA shared; 12  Number of shared segments
# 13  Largest segment (cM); 14  Review DNA Match page; 15  Has family tree
# 16  Number of individuals in the tree; 17  Tree managed by; 18  View tree
# 19  Contact tree manager; 20  Number of Smart Matches
# 21  Shared Ancestral Surnames; 22  All ancestral surnames; 23  Notes
# 24  Has Theory of Family Relativity™

TAB=$(printf "\t")
DATE="$(date +%Y-%m-%d)"

target=$1

unzip -p "$target" | head -100 | tee temp1 | xsv select 9 | tr -d '"' |
    awk -F, '{print $1}' > temp2

xsv select 2,10-13 temp1 > temp3

paste temp2 temp3 | sed "s/$TAB/,/g" | xsv select 2,1,3-6 | awk -f fixFields.awk \
    >Match-MyHeritage_$DATE.csv

rm temp?
