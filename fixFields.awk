# Grab appropriate fields from DNA_Match_Manager output

BEGIN {
    FS=","
    # stop at 99.5 cMs (to handle rounding up to 100) unless cMs_min is set
    if (cMs_min  == "") cMs_min  = 99.5
    cMs_pct_factor = 74.6   # Used to convert cMs to pct and vice versa
}

/^Name/ {
    header = "My Heritage,,,"
    printf "Source Site,Email,Match Gender,Match Name"
    printf ",mh_Estimated Relationship,mh_Total cM Shared"
    printf ",mh_Percent DNA Shared,mh_Number Shared Segments"
    printf ",mh_Largest Segment cM\n"
    next
}

/Display Name/ {
    header = "23 & Me,,"
    printf "Source Site,Email,Match Name,Match Gender"
    printf ",23_Set Relationship,23_Percent DNA Shared"
    printf ",23_# Segments Shared\n"
    next
}

{
    sub (/,\)/,"\)")
    gsub (/"/,"")
    gsub (/Cousin, /,"Cousin; ")
    printf ("%s",header)
    print
}
