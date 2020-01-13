# Grab appropriate fields from DNA_Match_Manager output

BEGIN {
    FS="\t"
    # stop at 99.5 cMs (to handle rounding up to 100) unless cMs_min is set
    if (cMs_min  == "") cMs_min  = 99.5
}

/^Source Site/ {
    for ( i = 1; i <= NF; i++ ) {
        if ($i == "Source Site") Source = i
        if ($i == "Match Name") Name = i
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
    print "Source Site\tMatch Name\tSide\tSex\tShared %\tShared cMs\tShared Segs\tLongest Seg\tRelationship"
    next
}

/^23 & Me/ {
    if ($tw_pct*74.6 < cMs_min) next
    pct = $tw_pct
    cMs = $tw_pct*74.6
    segs = $tw_segs
    longest_cM = ""
    relationship = $tw_relationship
}

/^Ancestry/ {
    if ($an_cMs < cMs_min) exit
    pct = $an_cMs/74.6
    cMs = $an_cMs
    segs = $an_segs
    longest_cM = ""
    relationship = $an_relationship
}

/^FTDNA/ {
    if ($ft_cMs < cMs_min) exit
    pct = $ft_cMs/74.6
    cMs = $ft_cMs
    segs = ""
    longest_cM = $ft_longest_cM
    relationship = $ft_relationship
}

/^GEDMatch/ {
    if ($gm_cMs < cMs_min) exit
    pct = $gm_cMs/74.6
    cMs = $gm_cMs
    segs = ""
    longest_cM = sprintf("%d",$gm_longest_cM)
    relationship = $gm_relationship
}

/^My Heritage/ {
    if ($mh_cMs < cMs_min) exit
    pct = $mh_pct
    cMs = $mh_cMs
    segs = $mh_segs
    longest_cM = sprintf("%d",$mh_longest_cM)
    relationship = $mh_relationship
}

{
    # "Source  Name  Side  Gender  Pct  cMs  Segs  Longest  Relationship"
    sex = $Gender
    sub (/Female/,"F",sex)
    sub (/Male/,"M",sex)
    sub (/U/,"",sex)
    sub (/PARENT_CHILD/,"Son",relationship)
    sub (/FIRST_COUSIN/,"1st cousin",relationship)
    sub (/SECOND_COUSIN/,"2nd cousin",relationship)
    sub (/THIRD_COUSIN/,"3rd cousin",relationship)
    gsub (/Cousin/,"cousin",relationship)
    gsub (/; Once Removed/," - once removed",relationship)
    gsub (/; Twice Removed/," - twice removed",relationship)
    printf ("%s\t%s\t\t%s\t%.2f\t%.0f\t%s\t%s\t%s\n", $Source ,$Name, \
            sex, pct, cMs, segs, longest_cM, relationship)
}
