## DNA Match Manager Helper

[DNA Match Manager]:https://heirloomsoftware.com/dna-match-manager/
[DNA Match Manager Helper]:https://github.com/Monty/DNA_Match_Manager_Helper
[cvskit]:http://csvkit.rtfd.org
[columns]:DNA_Match_Manager-FieldNames.md
[Windows Subsystem for Linux]:https://docs.microsoft.com/en-us/windows/wsl/faq

**[DNA Match Manager][]** is a free program that downloads DNA match data from
Ancestry, 23andMe, FamilyTreeDNA, GEDmatch, and MyHeritage (*in minutes instead
of days*). However, some important numeric data in its output files, such as
Shared cMs, is in a [different column for each site][columns]. That makes it
difficult to sort into a useful order.

The shell script **makeDNASpreadsheet.sh** overcomes that problem by extracting
and coalescing data from those files into a summary spreadsheet sorted by
Shared cMs, Shared %, and then Match Name so that the closest DNA relatives are
at the top.

The resulting spreadsheet contains the following columns:

| Column | Description |
|--------:|:-------------|
| Source Site | Site the data came from - *e.g. Ancestry, 23andMe, etc.* |
| Match Name | Name of the person who is a DNA match |
| Side | P, M, or blank - *i.e. P[aternal] or M[aternal]* |
| Gender | M, F, or blank |
| Shared % | Percentage of DNA shared - *computed if not provided* |
| Shared cMs | Total amount of DNA shared (*in cMs*) |
| Shared Segs | Total number of DNA segments shared |
| Longest Seg | Size (*in cMs*) of largest matching segment |
| Relationship | Varies - *e.g. GEDmatch uses a number instead of text* |


### Prerequisites

In addition to **[DNA Match Manager][]** you'll need csvformat, which is
included in **[cvskit][]**, and the standard utilities bash, awk, grep, and
python. ***Note:*** *Installing cvskit requires both python and pip. If they
aren't already installed, you should be able to find installation instructions
on the web.*

### Compatibility

Tested on macOS Mojave and Catalina. Tested on Ubuntu 18.04. Should work in
Windows 10 under **[Windows Subsystem for Linux][]** as long as prerequisites
are satisfied.

### Instructions

1. Clone or download **[DNA Match Manager Helper][]**.

2. Run **[DNA Match Manager][]** to collect data from any sites you use. Save
(*in the directory created in step 1*) either a file per site or a single
file containing all sites. Include **one** of these key strings in the name you
choose for each output file. Be consistent in your methodology!

    * 23andMe
    * Ancestry
    * FTDNA
    * GEDmatch
    * MyHeritage
    * AllSites - *Only if you choose to use a single file to contain all data*

    For example, instead of the default
**`MatchManagerExport_1.13.2020.2.48.28PM.csv`** save your 23andMe match data
as **`Match-23andMe_1.13.2020.2.48.28PM.csv`** (*or any other name containing
"23andMe"*).

3. In a terminal window, type: **`./makeDNASpreadsheet.sh`** to generate a
match summary spreadsheet and (*if there are any*) a list of matches added
since the previous run. They will have *timestamped* names such as
Relatives-*200111.103106*.csv and Additions-*200111.103106*.csv

    Or you can simply double click **`run.command`** in a Finder window (*or
right-click and select 'Open'*) which will automatically open a Terminal window
and run **`./makeDNASpreadsheet.sh`** for you.

    By default, only matches sharing more than 100 cMs are saved. This is
appropriate for adoptees or others seeking close DNA relatives. If you are
doing genealogy research a lower minimum will be more helpful.

    To change the minimum cMs saved, use the **-m** switch, e.g. in a terminal
window type: **`./makeDNASpreadsheet.sh -m 19.5`** ***Note:*** *If you want 20
cM, enter 19.5 as some web sites show cMs rounded up to the next whole number.*

### ProTips

Create a permanent master spreadsheet from the Relatives-*timestamp*.csv file
and save it as a non-csv spreadsheet. Use that spreadsheet to make notes, add
missing data, and change erroneous relationships (*e.g. second cousin to first
cousin once removed, etc.*). Add as many columns as you need for things like
email address, most recent common ancestor, birth year, location, common
surnames, etc.

Don't delete the Relatives-*timestamp*.csv file produced by this script. It
will be used by later runs to produce an Additions-*timestamp*.csv file
containing data that can be cut/pasted into your master spreadsheet. You can
either paste that data one line at a time into its proper slot, or paste it all
at the bottom and then sort it by Shared cMs (*descending*), Shared %
(*descending*), and then Match Name (*ascending*) to move it into the correct
slot.

There is no reason to run **`./makeDNASpreadsheet.sh`** again until you know or
suspect you have a new relative that shares more DNA than the minimum cMs
saved. Run it monthly if you don't keep a close watch on your DNA testing
sites.

If you want to see what added matches will look like without waiting for new
ones to show up on the web, just reduce the minimum cMs slightly, e.g.
**`./makeDNASpreadsheet.sh -m 99`**

Enjoy!
