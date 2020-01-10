#!/usr/bin/env bash
# Process most recent DNA spreadsheets and generate diffs

DATE="$(date +%y%m%d)"
LONGDATE="$(date +%y%m%d.%H%M%S)"

AN_CURRENT=$(ls -1t MatchManagerExport-Ancestry_*.csv | head -1)
FT_CURRENT=$(ls -1t MatchManagerExport-FTDNA_*.csv | head -1)
GM_CURRENT=$(ls -1t MatchManagerExport-GEDmatch_*.csv | head -1)
MH_CURRENT=$(ls -1t MatchManagerExport-MyHeritage_*.csv | head -1)
TW_CURRENT=$(ls -1t MatchManagerExport-23andMe_*.csv | head -1)
ALL_CURRENT=$(ls -1t all-*csv | head -1)

echo "Processing these current files:"
echo $AN_CURRENT
echo $FT_CURRENT
echo $GM_CURRENT
echo $MH_CURRENT
echo $TW_CURRENT
echo $ALL_CURRENT

AN_NEW="AN-$DATE.csv"
FT_NEW="FT-$DATE.csv"
GM_NEW="GM-$DATE.csv"
MH_NEW="MH-$DATE.csv"
TW_NEW="TW-$DATE.csv"

ALL_NEW="all-$LONGDATE.csv"

./makeOneDNASPreadsheet.sh $AN_CURRENT >$AN_NEW
./makeOneDNASPreadsheet.sh $FT_CURRENT >$FT_NEW
./makeOneDNASPreadsheet.sh $GM_CURRENT >$GM_NEW
./makeOneDNASPreadsheet.sh $MH_CURRENT >$MH_NEW
./makeOneDNASPreadsheet.sh $TW_CURRENT >$TW_NEW

cp head.txt $ALL_NEW
grep -vh "^Source Site" $AN_NEW $FT_NEW $GM_NEW $MH_NEW $TW_NEW | sort -u |
    sort --field-separator=$'\t' --key=6,6nr --key=5,5nr -f --key=2,2 >>$ALL_NEW

echo "Differences from previous run:"
diff -U 1 $ALL_CURRENT $ALL_NEW

echo ""
echo "Additions from previous run:"
diff $ALL_CURRENT $ALL_NEW | grep "^>"
