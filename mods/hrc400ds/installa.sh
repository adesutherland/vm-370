#!/bin/sh
# HRC400DS Mod - Contributed by Bob Bolch
# Predicate - logged on as MAINT
#           - Needs buildnuc.sh run afterwards
# PART A - The MOD

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

# Add the requred change to the top of each file
herccontrol "/edit NUCON AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC400DS v01 add HI, TS, and TE commands"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSCIT AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC400DS v01 add HI, TS, and TE commands"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

# Install Mod
herccontrol "/installa" -w "^Ready;"
herccontrol "/erase installa exec a" -w "^Ready;"
