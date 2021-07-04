#!/usr/bin/env bash

# Fix FTDNA downloaded file

# 1   Full Name 2   First Name 3   Middle Name 4   Last Name 5   Match Date 6   Relationship Range
# 7   Shared DNA 8   Longest Block 9   Linked Relationship 10  Ancestral Surnames
# 11  Y-DNA Haplogroup 12  mtDNA Haplogroup 13  Notes 14  Matching Bucket

DATE="$(date +%Y-%m-%d)"

target=$1
xsv select 1,7,6,8 "$target" | awk -f fixFields.awk >Match-FTDNA_$DATE.csv

