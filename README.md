## DNA Match Manager Helper

[**DNA Match Manager**](https://heirloomsoftware.com/dna-match-manager/) is a
free program that downloads DNA match data from Ancestry, 23 & Me, Family Tree
DNA, GedMatch Genesis, and My Heritage (*in minutes instead of days*). However,
some important numeric data in its output file, such as Shared cMs, is in a
[different column for each site](DNA_Match_Manager-FieldNames.md). That makes it difficult to sort into a useful
order.

This program will extract and coalesce data from those files into a summary
spreadsheet sorted by Shared cMs, Shared %, and then Match Name so that closest
DNA relatives are at the top.

The resulting spreadsheet contains the following columns:

| Column | Description |
|--------:|:-------------|
| Source Site | Site the data came from - *e.g. Ancestry, 23 & Me, etc.* |
| Match Name | Name of the person who is a DNA match |
| Side | P, M, or blank - *i.e. P[aternal] or M[aternal]* |
| Gender | M, F, or blank |
| Shared % | Percentage of DNA shared - *computed if not provided* |
| Shared cMs | Total amount of DNA shared (*in centiMorgans*) |
| Shared Segs | Total number of DNA segments shared |
| Longest Seg | Size (*in cM*) of largest matching segment |
| Relationship | Varies - *e.g. GedMatch uses a number instead of text* |


### Prerequisites
In addition to [**DNA Match
Manager**](https://heirloomsoftware.com/dna-match-manager/) you'll need
csvformat, which is included in [cvskit](http://csvkit.rtfd.org/), and the
standard utilities bash, awk, grep, and python.

### Instructions
Run DNA Match Manager to collect data from sites you use. Save a file per site,
or a single file containing all sites. Include **one** of these key strings in
each output file name. Be consistent!

* 23andMe
* Ancestry
* FTDNA
* GEDmatch
* MyHeritage
* AllSites

For example, save as `Match-Ancestry_1.13.2020.2.48.28PM.csv`instead of
`MatchManagerExport_1.13.2020.2.48.28PM.csv`

Run `./makeAllDNASpreadsheets.sh` to collect all matches sharing 100 cMs or
more.  To change the minimum cMs saved, use the -m switch, i.e.
`./makeAllDNASpreadsheets.sh -m 49.5` *Note: if you want 50 cM, enter 49.5 as
some web sites show cMs rounded up to the next whole number.*

### ProTips
Create a permanent master spreadsheet from the output file and save it in a non-csv
format. Use it to make notes, add missing data, and change erroneous
relationships (*e.g. second cousin to first cousin once removed, etc.*).

Don't delete the previous output file produced by this program. This will enable
the program to produce a list of additions in a format that can be cut/pasted
into your master spreadsheet. You can either paste those a line at a time into
the proper slot, or paste them all at the bottom and then sort the master
spreadsheet by Shared cMs, Shared %, and then Match Name to move them into the
correct slot.

There is no reason to run this program again until you know or suspect you have a 
new relative that shares more DNA than the minimum saved. Run it monthly if you
don't keep a close watch on your DNA testing sites.

Enjoy!
