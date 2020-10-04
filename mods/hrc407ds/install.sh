#!/bin/sh
# HRC407DS Mod - Contributed by Bob Bolch
# Predicate - logged on as MAINT
#           - Needs regen.sh run afterwards

# Exit if there is an error
set -e

# Send YATA TXT
herccontrol "/purge rdr" -w "^Ready;"
yata -c
herccontrol -m >tmp; read mark <tmp; rm tmp
echo "USERID  MAINT\n:READ  YATA     TXT     " > tmp

cat yata.txt >> tmp
netcat -q 0 localhost 3505 < tmp
rm tmp
herccontrol -w "HHCRD012I" -f $mark
herccontrol "/" -w "RDR FILE"
herccontrol "/read *" -w "^Ready;"
herccontrol "/yata -x" -w "^Ready;"
herccontrol "/erase yata txt a" -w "^Ready;"

# Access the CMS local modifications disk for write
herccontrol "/access 093 b" -w "^Ready;"
herccontrol "/access 190 e" -w "^Ready;"

# Add the requred change to the top of each file
herccontrol "/edit DMSQRY AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC407DS V01 Add SET EXECTRAC command for REXX"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSSET AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC407DS V01 Add SET EXECTRAC command for REXX"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

# Install Mod
herccontrol "/install" -w "^Ready;"
herccontrol "/erase install exec a" -w "^Ready;"
