# Grab appropriate fields from DNA_Match_Manager output

BEGIN {
    FS=","
    # stop at 99.5 cMs (to handle rounding up to 100) unless cMs_min is set
    if (cMs_min  == "") cMs_min  = 99.5
    cMs_pct_factor = 74.6   # Used to convert cMs to pct and vice versa
}

/^Source Site/ {
    for ( i = 1; i <= NF; i++ ) {
        ### To add a site specific column, add an if statement below. The file awkStatements.txt will help.
        if ($i == "Source Site") Source = i
        if ($i == "Match Name") Name = i
        if ($i == "Email") Email = i
        if ($i == "Match Gender") Gender = i
        if ($i == "an_Shared cM") an_cMs = i
        if ($i == "an_Shared Segments") an_segs = i
        if ($i == "an_Group Name") an_relationship = i
        if ($i == "gm_Generation") gm_relationship = i
        if ($i == "gm_Largest Segment") gm_longest_cM = i
        if ($i == "gm_Total cM") gm_cMs = i
        if ($i == "ft_Total cM") ft_cMs = i
        if ($i == "ft_Suggested Relationship") ft_relationship = i
        if ($i == "ft_Longest Centimorgans") ft_longest_cM = i
        if ($i == "23_Set Relationship") tw_relationship = i
        if ($i == "23_Percent DNA Shared") tw_pct = i
        if ($i == "23_# Segments Shared") tw_segs = i
        if ($i == "mh_Estimated Relationship") mh_relationship = i
        if ($i == "mh_Total cM Shared") mh_cMs = i
        if ($i == "mh_Percent DNA Shared") mh_pct = i
        if ($i == "mh_Number Shared Segments") mh_segs = i
        if ($i == "mh_Largest Segment cM") mh_longest_cM = i
    }
    ### To add a column change the following line.
    print "Source Site\tMatch Name\tEmail\tSide\tSex\tShared %\tShared cMs\tShared Segs\tLongest Seg\tRelationship"
    next
}

### To add a site specific column change each of the folllowing clauses.
/^23 & Me/ {
    if ($tw_pct*cMs_pct_factor < cMs_min) next
    side = ""
    pct = $tw_pct
    cMs = $tw_pct*cMs_pct_factor
    segs = $tw_segs
    longest_cM = ""
    relationship = $tw_relationship
}

/^Ancestry/ {
    if ($an_cMs < cMs_min) next
    side = ""
    pct = $an_cMs/cMs_pct_factor
    cMs = $an_cMs
    segs = $an_segs
    longest_cM = ""
    relationship = $an_relationship
}

/^FTDNA/ {
    if ($ft_cMs < cMs_min) next
    side = ""
    pct = $ft_cMs/cMs_pct_factor
    cMs = $ft_cMs
    segs = ""
    longest_cM = $ft_longest_cM
    relationship = $ft_relationship
}

/^GEDMatch/ {
    if ($gm_cMs < cMs_min) next
    side = ""
    pct = $gm_cMs/cMs_pct_factor
    cMs = $gm_cMs
    segs = ""
    longest_cM = sprintf("%d",$gm_longest_cM)
    relationship = $gm_relationship
}

/^My Heritage/ {
    if ($mh_cMs < cMs_min) next
    side = ""
    pct = $mh_pct
    cMs = $mh_cMs
    segs = $mh_segs
    longest_cM = sprintf("%d",$mh_longest_cM)
    relationship = $mh_relationship
}

{
    sex = $Gender
    # Sometimes, FTDNA puts two spaces between names. Make it a single space. 
    gsub (/  /," ",$Name)
    sub (/Female/,"F",sex)
    sub (/Male/,"M",sex)
    sub (/U/,"",sex)
    sub (/PARENT_CHILD/,"Parent or child",relationship)
    sub (/CLOSE_FAMILY/,"Close family",relationship)
    sub (/FIRST_COUSIN/,"1st cousin",relationship)
    sub (/SECOND_COUSIN/,"2nd cousin",relationship)
    sub (/THIRD_COUSIN/,"3rd cousin",relationship)
    gsub (/Cousin/,"cousin",relationship)
    gsub (/; Once Removed/," - once removed",relationship)
    gsub (/; Twice Removed/," - twice removed",relationship)
    ### To add a column change the following 2 comment lines. Ditto in makeDNASpreadsheet.sh
    #      1      2      3     4      5      6    7    8      9           10
    #    Source  Name  Email  Side  Gender  Pct  cMs  Segs  Longest  Relationship
    ### To add a column change the following statement.
    printf ("%s\t%s\t%s\t%s\t%s\t%.2f\t%.0f\t%s\t%s\t%s\n", $Source ,$Name, $Email, \
            side, sex, pct, cMs, segs, longest_cM, relationship)
}
