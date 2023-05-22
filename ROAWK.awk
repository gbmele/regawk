##gawk -f ROAWK.awk term2.csv staff_registrars.csv reg_shift_codes.csv reg_rosteron.csv
   ##
BEGIN{
  ##dump = "dump.csv"
  FS=","        ;   OFS    = "*"
  area = "12240-B0041-03"
  dag_end= "R" OFS "N" OFS " "OFS " " OFS " " OFS "N" OFS "N" OFS "N" OFS "N" OFS "N" OFS "N" OFS "N" OFS "N" OFS "N" OFS "N" OFS "N"
   
  _DATES  =  1 ;   _STAFF  = 2  ;  _SHIFTS = 3  ; _ROSTER = 4
}
FILENAME == ARGV[_DATES]   { DATES [FNR]  = $1 ; next }    # just 1 field ddmmYYYY
FILENAME == ARGV[_STAFF]   {       _empnum=2 ; _role=3 ; _fullpart=4
                                    ID[$1]    = $1 
                                   empnum[$1] = $_empnum
                                    role[$1]  = $_role
                                 fullpart[$1] = $_fullpart
                            next}
FILENAME == ARGV[_SHIFTS]   {  ##reg shifts -
                               _code=1  ; _mzcode = 2;  _rocode=3 ; _start=4; _finish=5; _hrs=6; _oc1=7; _oc2=8
                               shift_key[$1]  = area OFS $_rocode OFS $_start OFS $_finish OFS $_hrs OFS $_oc1 OFS $_oc2 # OFS dag_end
                            next}

FILENAME == ARGV[_ROSTER]  {    day=1 ; doc=2 ; shift=3
                                c=split($0,line,",")
                                the_shift = line[shift]
                                the_date = DATES[line[day]]
                                the_empnum=empnum[line[doc]]
                                the_role = role[line[doc]]

                                if (the_shift > 0) {print the_date,the_empnum,area,the_role,shift_key[the_shift]
                                }
                                ##TEACHING IF WEDNESDAY
                                if(line[day]%7==3 && fullpart[line[doc]] == "FT")  
                                    {print the_date,the_empnum,area,the_role,shift_key[9]  }
                                if(line[day]%7==3 && fullpart[line[doc]] == "PT")  
                                    {print the_date,the_empnum,area,the_role,shift_key[91]  }
                                if(line[day]%7==3 && fullpart[line[doc]] == "34T") 
                                    {print the_date,the_empnum,area,the_role,shift_key[92]  }
                           next
                           }
END{
##chaining TERNARY operators
num=2
  print num == 1 && 2==3                 ? "yes"                             : 
        num == 2 &&  index(123,1)        ?  "index stufff works as true  "   :
        "fall through"
}
