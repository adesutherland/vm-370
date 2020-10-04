#!/bin/sh
# HRC406DS Mod - Contributed by Bob Bolch
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
herccontrol "/access 190 e" -w "^Ready;"

# Add the requred change to the top of each file
herccontrol "/edit NUCON AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC406DS V01 Support for MAKEBUF, DROPBUF, and SENTRIES"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSBUF AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC406DS V01 Support for MAKEBUF, DROPBUF, and SENTRIES"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSCAT AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC406DS V01 Support for MAKEBUF, DROPBUF, and SENTRIES"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSCIT AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC406DS V01 Support for MAKEBUF, DROPBUF, and SENTRIES"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSCRD AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC406DS V01 Support for MAKEBUF, DROPBUF, and SENTRIES"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSEXT AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC406DS V01 Support for MAKEBUF, DROPBUF, and SENTRIES"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSFNC AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC406DS V01 Support for MAKEBUF, DROPBUF, and SENTRIES"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSNUC AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC406DS V01 Support for MAKEBUF, DROPBUF, and SENTRIES"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSBUF AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC406DS V01 Support for MAKEBUF, DROPBUF, and SENTRIES"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

# Update the CMSLOAD EXEC file
herccontrol "/edit CMSLOAD EXEC E (nodisp" -w "^EDIT:"
herccontrol "//DMSTIO"
herccontrol "/input" -w "^INPUT:"
herccontrol "/&1 &2 &3 DMSBUF"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

# Install Mod
herccontrol "/install" -w "^Ready;"
herccontrol "/erase install exec a" -w "^Ready;"
