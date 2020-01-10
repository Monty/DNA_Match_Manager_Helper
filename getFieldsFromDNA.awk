# Grab appropriate fields from DNA_Match_Manager output

BEGIN {
    FS="\t"
    print "Source Site\tMatch Name\tSide\tSex\tShared %\tShared cMs\tShared Segs\tLongest Seg\tRelationship"
    # stop at 99.5 cMs (to handle rounding up to 100) unless cMs_min is set
    if (cMs_min  == "") cMs_min  = 99.5
}

/^Source Site/ {
    for ( i = 1; i <= NF; i++ ) {
        if ($i == "Source Site") Source = i
        if ($i == "Match Name") Name = i
        if ($i == "Match Gender") gender = i
        if ($i == "23_Percent DNA Shared") tw_pct = i
        if ($i == "23_# Segments Shared") tw_segs = i
        if ($i == "23_Set Relationship") tw_relationship = i
        if ($i == "an_Shared cM") an_cMs = i
        if ($i == "an_Shared Segments") an_segs = i
        if ($i == "an_Group Name") an_relationship = i
        if ($i == "ft_Total cM") ft_cMs = i
        if ($i == "ft_Longest Centimorgans") ft_longest_cM = i
        if ($i == "ft_Suggested Relationship") ft_relationship = i
        if ($i == "gm_Total cM") gm_cMs = i
        if ($i == "gm_Largest Segment") gm_longest_cM = i
        if ($i == "gm_Generation") gm_relationship = i
        if ($i == "mh_Percent DNA Shared") mh_pct = i
        if ($i == "mh_Total cM Shared") mh_cMs = i
        if ($i == "mh_Number Shared Segments") mh_segs = i
        if ($i == "mh_Largest Segment cM") mh_longest_cM = i
        if ($i == "mh_Estimated Relationship") mh_relationship = i
    }
}

/^23 & Me/ {
    if ($tw_pct*74.6 >= cMs_min) printf ("%s\t%s\t\t%s\t%.2f\t%.0f\t%d\t\t%s\n", $Source ,$Name,\
        substr($gender,1,1), $tw_pct, $tw_pct*74.6, $tw_segs, $tw_relationship)
}

/^Ancestry/ {
    if ($an_cMs < cMs_min) exit
    printf ("%s\t%s\t\t%s\t%.2f\t%.0f\t%d\t\t%s\n", $Source ,$Name,\
            $gender, $an_cMs/74.6, $an_cMs, $an_segs, $an_relationship)
}

/^FTDNA/ {
    if ($ft_cMs < cMs_min) exit
    printf ("%s\t%s\t\t%s\t%.2f\t%.0f\t\t%d\t%s\n", $Source ,$Name,\
            $gender, $ft_cMs/74.6, $ft_cMs, $ft_longest_cM, $ft_relationship)
}

/^GEDMatch/ {
    if ($gm_cMs < cMs_min) exit
    printf ("%s\t%s\t\t\t%.2f\t%.0f\t\t%d\t%.1f\n", $Source ,$Name,\
            $gm_cMs/74.6, $gm_cMs, $gm_longest_cM, $gm_relationship)
}

/^My Heritage/ {
    if ($mh_cMs < cMs_min) exit
    printf ("%s\t%s\t\t\t%.2f\t%.0f\t%d\t%d\t%s\n", $Source ,$Name,\
            $mh_pct, $mh_cMs, $mh_segs, $mh_longest_cM, $mh_relationship)
}
