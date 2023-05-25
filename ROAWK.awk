##gawk -f ROAWK.awk term2.csv staff_registrars.csv reg_shift_codes.csv reg_rosteron.csv
   ##

BEGIN{             
     _DATES  =  1
     _STAFF  =  2 
     _SHIFTS =  3  
     _ROSTER =  4

dump = "reg_dump.csv"
  FS  =  "," 
  OFS = ","
  area = "12240-B0041-03"
  dag_end= "R" OFS "N" OFS " "OFS " " OFS " " OFS "N" OFS "N" OFS "N" OFS "N" OFS "N" OFS "N" OFS "N" OFS "N" OFS "N" OFS "N" OFS "N"
}
FILENAME == ARGV[_DATES]   { DATES [FNR]  = $1
                            next }    # just 1 field ddmmYYYY

FILENAME == ARGV[_STAFF]   {       
                            _empnum=2 ; _role=3 ; _fullpart=4
                                    ID[$1]    = $1 
                                   empnum[$1] = $_empnum
                                    role[$1]  = $_role
                                 fullpart[$1] = $_fullpart 
                            next}

FILENAME == ARGV[_SHIFTS]   {  ##reg shifts -
                               _code=1  ; _mzcode = 2;  _rocode=3 ; _start=4; _finish=5; _hrs=6; _oc1=7; _oc2=8
                              rocode[$1]     =$_rocode
                              shift_key[$1]  = $_start OFS $_finish OFS $_hrs OFS $_oc1 OFS $_oc2
                            next}

FILENAME == ARGV[_ROSTER]  {    day=1 ; _doc=2 ; _shift=3
                                the_day = $day
                                the_shift = $_shift
                                the_date = DATES[$day]
                                the_empnum=empnum[$_doc]
                                the_role = role[$_doc]
                              the_shift_code=rocode[the_shift]
                                  EFT = fullpart[$_doc]
                                night_shift = 7
                                wednesday = 3
                               ## match(the_shift,3) ensures the shift is a short wed shift.

                                if (the_shift > 0)
                                        {print the_empnum,the_date,area,the_shift_code,the_role,shift_key[the_shift]  OFS dag_end  >dump }
                                
                                ##TEACHING IF WEDNESDAY  night shift is 7
#                                teach_stub = the_empnum OFS the_date OFS area
                                
                                if(the_day % 7 == wednesday && EFT == "FT" && the_shift>0 && match(the_shift,3) && the_shift != night_shift)  
                                              {print the_empnum,the_date,area,the_shift_code,the_role,shift_key[9]  OFS dag_end   >dump      }
                                
                                if(the_day % 7 == wednesday && EFT == "PT" && the_shift>0 && match(the_shift,3) && the_shift != night_shift) 
                                              {print the_empnum,the_date,area,the_shift_code,the_role,shift_key[91]  OFS dag_end   >dump     }
                                
                                if(the_day %7 == wednesday && EFT == "34T" && the_shift>0 && match(the_shift,3) && the_shift != night_shift )
                                              {print the_empnum,the_date,area,the_shift_code,the_role,shift_key[92]  OFS dag_end    >dump      }
                           next
                           }
END{
##chaining TERNARY operators
num=2
  print num == 1 && 2==3                 ? "yes"                             : 
        num == 2 &&  index(123,1)        ?  "index stufff works as true  "   :
      ""
print "file written to was " dump 
}
