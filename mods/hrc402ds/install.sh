#!/bin/sh
# HRC402DS Mod - Thanks to Bob Bolch!
# Predicate - logged on as MAINT
#           - Needs buildnuc.sh run afterwards

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
herccontrol "/edit DMSEXC AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC402DS V01 Support execution of REXX programs as filetype EXEC"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit IO AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC402DS V01 Support execution of REXX programs as filetype EXEC"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

# Add IO MACRO to library list CMSHRC EXEC B
herccontrol "/edit CMSHRC EXEC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/&1 &2 IO       MACRO"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

# Install Mod
herccontrol "/install" -w "^Ready;"
herccontrol "/erase install exec a" -w "^Ready;"
