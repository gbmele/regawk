## INDIRECTION
##arry["b"] = "c"
##a = "b"
##print arry[a] --> "c"


##gawk -f rosteronbuild.awk reg_rosteron.csv term2.csv staff_registrars.csv shifts.csv
   ##
BEGIN{
  FS=","
  sp = "*"
  #string: dag_end = join(sep,["R","N"," "," "," ","N","N","N","N","N","N","N","N","N","N","N"]);
  dag_end= "R" sp "N" sp " "sp " " sp " " "N" sp "N" sp "N" sp "N" sp "N" sp "N" sp "N" sp "N" sp "N" sp "N" sp "N"
  _ROSTER= 1    #$1 day $2 doc $3 shift
  _DATES = 2    # $1
  _STAFF = 3    #  $1 
  _SHIFTS = 4   # 
}
#these 4 files are csv files 
FILENAME == ARGV[_ROSTER]  { ROSTER[FNR]  = $0 ; next }    #load a csv in full
FILENAME == ARGV[_DATES]   { DATES [FNR]  = $1 ; next }    # just 1 field
FILENAME == ARGV[_STAFF]   { STAFF [FNR]  = $0 ; next }    # csv in full
FILENAME == ARGV[_SHIFTS]  { SHIFTS[FNR]  = $0 ; next }    # csv in full 

END{
  ## STAFF
  ##  code=1 ;  empnum=2;      role=3;  fullpart=4; #,comment, surname, firstname
  ##   1     2                   3            4          5       6        7
  for(i=1;i<=length(STAFF);i++){
      c=split(STAFF[i],ss)
       empnum[i]   = ss[2]    
       role[i]     = ss[3]
       fullpart[i] = ss[4]
       name[i]     = ss[6]    
  }


##  SHIFTS  
##  key,Area,Shift,Start Time,Finish Time,Shift Hrs,Oncall From Time,Oncall To Time
##   1    2     3       4            5          6          7                  8
    for (i=1; i <=length(SHIFTS);i++){
       c = split(SHIFTS[i],temp,",")
       shiftkey[temp[1]] = temp[2] sp temp[3] sp temp[4] sp temp[5] sp temp[6] sp temp[7] sp temp[8] 
       area[i] = temp[2]
 }
## ROSTER is LINES OF DAY DOC SHIFT
## ROSTER     DAY DOC SHIFT
##  LINE      1    2   3    
  day = 1    ; doc = 2   ;  shift = 3
 
  for(i=1;i<=length(ROSTER);i++){
     c=split(ROSTER[i],LINE)
     if (LINE[shift] !=0) {
               print empnum[LINE[doc]] sp \
                DATES[LINE[day]] sp \
                area[LINE[shift]] sp role[LINE[doc]] sp shiftkey[LINE[shift]]  #sp dag_end
          }
   }
  #PRINT TEACHING
  ## day mod 7 = 3 === WEDNESDAY,  so 3 to length(ROSTER) step 7 is everywednesday
  for(i=3;i<=length(ROSTER);i+=7){
            c=split(ROSTER[i],LINE)
          if (fullpart[LINE[doc]] =="FT")  {print  "FT_TEACH"}
     else if (fullpart[LINE[doc]] =="PT")  {print "PT TEACHING TIME"}
     else if (fullpart[LINE[doc]] =="34T")  {print "34 TEACHING TIME"} 
   }

} #END END

