#!/usr/bin/env bash

# Fix My Heritage downloaded file

# 1  Display Name; 2  Surname; 3  Chromosome Number; 4  Chromosome Start Point
# 5  Chromosome End Point; 6  Genetic Distance; 7  # SNPs; 8  Full IBD
# 9  Link to Profile Page; 10  Sex; 11  Birth Year; 12  Set Relationship
# 13  Predicted Relationship; 14  Relative Range; 15  Percent DNA Shared
# 16  # Segments Shared; 17  Maternal Side; 18  Paternal Side
# 19  Maternal Haplogroup; 20  Paternal Haplogroup; 21  Family Surnames
# 22  Family Locations; 23  Maternal Grandmother Birth Country
# 24  Maternal Grandfather Birth Country; 25  Paternal Grandmother Birth Country
# 26  Paternal Grandfather Birth Country; 27  Notes; 28  Sharing Status
# 29  Showing Ancestry Results; 30  Family Tree URL

DATE="$(date +%Y-%m-%d)"

target=$1
xsv select 1,10,12,15,16 "$target" | awk -f fixFields.awk | sort -u |
    sort --key=1,1r --key=2,2 >Match-23andMe_$DATE.csv

