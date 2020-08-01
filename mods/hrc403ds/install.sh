#!/bin/sh
# HRC403DS Mod - Contributed by Bob Bolch
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
herccontrol "/edit BGCOM AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC403DS V01 Expand NUCON to 4K for future extensions"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit PIB2TAB AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC403DS V01 Expand NUCON to 4K for future extensions"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit NUCON AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC403DS V01 Expand NUCON to 4K for future extensions"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSNUC AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC403DS V01 Expand NUCON to 4K for future extensions"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSINT AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC403DS V01 Expand NUCON to 4K for future extensions"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

# Add New MACROs to library list CMSHRC EXEC B
herccontrol "/edit CMSHRC EXEC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/&1 &2 BGCOM    MACRO"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit CMSHRC EXEC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/&1 &2 PIB2TAB  MACRO"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

# Install Mod
herccontrol "/install" -w "^Ready;"
herccontrol "/erase install exec a" -w "^Ready;"
