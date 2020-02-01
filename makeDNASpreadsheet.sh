#!/usr/bin/env bash
# Process most recently downloaded DNA Match Manager spreadsheets and generate diffs

DATE="$(date +%Y-%m-%d)"
LONGDATE="$(date +%Y-%m-%d.%H%M%S)"

# Make sure we are in the correct directory
DIRNAME=$(dirname "$0")
cd $DIRNAME

# use "-m" to change minimum cMs, for example:
#     ./makeDNASpreadsheet.sh -m 19.5
# use .5 less than you actually want because cMs are rounded up on the Ancestry web page
# default is 100 cMs
cMs_min=99.5
while getopts ":m:" opt; do
    case $opt in
    m)
        cMs_min="$OPTARG"
        ;;
    \?)
        echo "[Warning] Ignoring invalid option: -$OPTARG" >&2
        ;;
    :)
        echo "[Error] Option -$OPTARG requires an argument" >&2
        exit 1
        ;;
    esac
done

# Generated spreadsheets
RELATIVES_NEW="Relatives-$LONGDATE.csv"
RELATIVES_TMP="Relatives-$LONGDATE.tmp"
ADDITIONS_NEW="Additions-$LONGDATE.csv"
# Make sure $RELATIVES_TMP exists and is empty
rm -f $RELATIVES_TMP
touch $RELATIVES_TMP
# Latest previously generated spreadsheet
find . -maxdepth 1 -name "Relatives-*.csv" | grep -q '^.'
if [ $? == 0 ]; then
    RELATIVES_CURRENT=$(ls -1t Relatives-*csv | head -1)
fi

# Process files downloaded by DNA Match Manager
# Use the latest .csv files with names containing one of these strings
KEYS=(23andMe Ancestry FTDNA GEDmatch MyHeritage AllSites)
#
echo "==> Processing these current files:"
for i in "${KEYS[@]}"; do
    target="*$i*.csv"
    find . -maxdepth 1 -name "$target" | grep -q '^.'
    if [ $? == 0 ]; then
        CURRENT_FILE=$(ls -1t $target | head -1)
        echo $CURRENT_FILE
        awk -v cMs_min=$cMs_min -f getFieldsFromDNA.awk $CURRENT_FILE >>$RELATIVES_TMP
    fi
done
echo ""

echo "==> Producing this new spreadsheet:"
echo "$RELATIVES_NEW"
# Grab generated header line and put it at top of new spreadsheet
grep -m 1 "^Source Site" $RELATIVES_TMP >$RELATIVES_NEW

### To add a column change the following 2 comment lines. Ditto in getFieldsFromDNA.awk
#      1      2      3     4      5      6    7    8      9           10
#    Source  Name  Email  Side  Gender  Pct  cMs  Segs  Longest  Relationship
# Sort by cMs, Pct, and then Name
### To add or move a column change the field numbers in the following statement
grep -v "^Source Site" $RELATIVES_TMP |
    sort -u | sort --field-separator=$'\t' --key=7,7nr --key=6,6nr -f --key=2,2 >>$RELATIVES_NEW
rm -f $RELATIVES_TMP

# If there is no current spreadsheet to compare against then exit
[ -z "$RELATIVES_CURRENT" ] && exit

diff -q $RELATIVES_CURRENT $RELATIVES_NEW >/dev/null 2>&1
if [ $? == 1 ]; then
    echo ""
    echo "==> Differences from the previous run:"
    diff -U 1 $RELATIVES_CURRENT $RELATIVES_NEW
    echo ""
    echo "==> These additions from the previous run have been saved in $ADDITIONS_NEW"
    diff $RELATIVES_CURRENT $RELATIVES_NEW | grep "^>" | cut -c 3- >$ADDITIONS_NEW
    cat $ADDITIONS_NEW
else
    echo ""
    echo "==> No differences from previous run."
fi
