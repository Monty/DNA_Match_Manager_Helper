#!/usr/bin/env bash
# Process most recent DNA spreadsheets and generate diffs

DATE="$(date +%y%m%d)"
LONGDATE="$(date +%y%m%d.%H%M%S)"

# Generated spreadsheets
RELATIVES_NEW="Relatives-$LONGDATE.csv"
RELATIVES_TMP="Relatives-$LONGDATE.tmp"
touch $RELATIVES_TMP
# Latest previously generated spreadsheet
find . -name "Relatives*.csv" -maxdepth 1 | grep -q '^.'
if [ $? == 0 ]; then
    RELATIVES_CURRENT=$(ls -1t Relatives-*csv | head -1)
fi

# Process files downloaded by DNA Match Manager
# Use the latest .csv files with names containing one of these strings
KEYS=(23andMe Ancestry FTDNA GEDmatch MyHeritage)
#
echo "==> Processing these current files:"
for i in "${KEYS[@]}"; do
    target="*$i*.csv"
    find . -name "$target" -maxdepth 1 | grep -q '^.'
    if [ $? == 0 ]; then
        CURRENT_FILE=$(ls -1t $target | head -1)
        echo $CURRENT_FILE
        ./makeOneDNASPreadsheet.sh $CURRENT_FILE >>$RELATIVES_TMP
    fi
done
echo ""

echo "==> Producing this new spreadsheet:"
echo "$RELATIVES_NEW"
# Grab header line
grep -m 1 "^Source Site" $RELATIVES_TMP >$RELATIVES_NEW
# Sort by cmS, pct, and then name
grep -v "^Source Site" $RELATIVES_TMP |
    sort -u | sort --field-separator=$'\t' --key=6,6nr --key=5,5nr -f --key=2,2 >>$RELATIVES_NEW
rm -f $RELATIVES_TMP

# If there is no current spreadsheet to compare iagainst then exit
[ -z "$RELATIVES_CURRENT" ] && exit

echo ""
echo "==> Differences from previous run:"
diff -U 1 $RELATIVES_CURRENT $RELATIVES_NEW

echo ""
echo "==> Additions from previous run:"
diff $RELATIVES_CURRENT $RELATIVES_NEW | grep "^>"
