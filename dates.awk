BEGIN{
###gawk -f dates.awk ddmmyyy days= number_of_days
dump = "tempdates.csv"
}
{
        d1 = mktime(substr(s,5,4) " " substr(s,3,2) " " substr(s,1,2)  " 0 0 0")
        for (d=1 ; d<=days ; d++){
 	           print "day " d " " strftime("%d/%m/%Y",d1)
             DATES[d]=strftime("%d/%m/%Y",d1)
             d1  += 86400
        }
}
END{
     print "array"
     for (i=1;i<=length(DATES);i++){
         print DATES[i]
         print DATES[i] > dump
     }
}