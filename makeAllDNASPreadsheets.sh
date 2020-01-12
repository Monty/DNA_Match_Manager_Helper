#!/usr/bin/env bash
# Process most recent DNA spreadsheets and generate diffs

DATE="$(date +%y%m%d)"
LONGDATE="$(date +%y%m%d.%H%M%S)"

AN_CURRENT=$(ls -1t *Ancestry_*.csv | head -1)
FT_CURRENT=$(ls -1t *FTDNA_*.csv | head -1)
GM_CURRENT=$(ls -1t *GEDmatch_*.csv | head -1)
MH_CURRENT=$(ls -1t *MyHeritage_*.csv | head -1)
TW_CURRENT=$(ls -1t *23andMe_*.csv | head -1)
RELATIVES_CURRENT=$(ls -1t Relatives-*csv | head -1)

echo "Processing these current files:"
echo $AN_CURRENT
echo $FT_CURRENT
echo $GM_CURRENT
echo $MH_CURRENT
echo $TW_CURRENT
echo $RELATIVES_CURRENT
echo ""

AN_NEW="AN-$DATE.csv"
FT_NEW="FT-$DATE.csv"
GM_NEW="GM-$DATE.csv"
MH_NEW="MH-$DATE.csv"
TW_NEW="TW-$DATE.csv"

RELATIVES_NEW="Relatives-$LONGDATE.csv"

echo "Producing this new file:"
echo "$RELATIVES_NEW"
echo ""

./makeOneDNASPreadsheet.sh $AN_CURRENT >$AN_NEW
./makeOneDNASPreadsheet.sh $FT_CURRENT >$FT_NEW
./makeOneDNASPreadsheet.sh $GM_CURRENT >$GM_NEW
./makeOneDNASPreadsheet.sh $MH_CURRENT >$MH_NEW
./makeOneDNASPreadsheet.sh $TW_CURRENT >$TW_NEW

sort -u $AN_NEW $FT_NEW $GM_NEW $MH_NEW $TW_NEW |
    sort --field-separator=$'\t' --key=6,6nr --key=5,5nr -f --key=2,2 >$RELATIVES_NEW

echo "Differences from previous run:"
diff -U 1 $RELATIVES_CURRENT $RELATIVES_NEW

echo ""
echo "Additions from previous run:"
diff $RELATIVES_CURRENT $RELATIVES_NEW | grep "^>"
