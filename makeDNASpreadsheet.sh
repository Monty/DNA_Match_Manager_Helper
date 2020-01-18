#!/usr/bin/env bash
# Process most recently downloaded DNA Match Manager spreadsheets and generate diffs

DATE="$(date +%y%m%d)"
LONGDATE="$(date +%y%m%d.%H%M%S)"

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

# Make sure we can execute csvformat.
if [ ! -x "$(which csvformat 2>/dev/null)" ]; then
    echo "[Error] Can't run csvformat. Install csvkit and rerun this script."
    echo "        See: https://csvkit.readthedocs.io/"
    echo "        To test after installing, type:  csvformat --version"
    exit 1
fi

# Generated spreadsheets
RELATIVES_NEW="Relatives-$LONGDATE.csv"
RELATIVES_TMP="Relatives-$LONGDATE.tmp"
ADDITIONS_NEW="Additions-$LONGDATE.csv"
# Make sure $RELATIVES_TMP exists and is empty
rm -f $RELATIVES_TMP
touch $RELATIVES_TMP
# Latest previously generated spreadsheet
find . -name "Relatives*.csv" -maxdepth 1 | grep -q '^.'
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
    find . -name "$target" -maxdepth 1 | grep -q '^.'
    if [ $? == 0 ]; then
        CURRENT_FILE=$(ls -1t $target | head -1)
        echo $CURRENT_FILE
        csvformat -T $CURRENT_FILE | awk -v cMs_min=$cMs_min -f getFieldsFromDNA.awk >>$RELATIVES_TMP
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
    echo "==> No differences from previous run"
fi
