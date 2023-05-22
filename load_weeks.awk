## 
## MY_COL1=1
## MY_COL2=3
##awk -v c1=$MY_COL1 -v c2=$MY_COL2 '{printf "%s\t%s\n", $c1, $c2}' < data_file.txt
#Note how the $1 and $3 in the original awk program are now $c1 and $c2 respectively and both of c1 and c2 variables are assigned values from the shell script variables using the -v parameter.

##So now you can redefine which columns are extracted by changing the shell script variable while leaving the awk command alone.

###
###
###gawk -f load_weeksAWK.txt w1.csv w2.csv w3.csv and so on till w13.cs
   ###
###
### 

BEGIN{
  FILENUM=0
  dump = "reg_rosteron.csv"
}

FNR == 1 { FILENUM++ }

         {
              dayone = (FILENUM-1)*7   ### (wknum-1)*7 is the sunday prior to the start of weeknum
              ct = split($0,FIELDS,",")
              for(i=1;i<=ct;i++){                      
                 printf "day-" dayone + i  " doc-" FNR       " shift-" FIELDS[i]"\n"
                 printf dayone + i","FNR","FIELDS[i]"\n" > dump
                  

              }
          }
          
END{
print "file written --- "dump 
}