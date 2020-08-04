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
herccontrol "/access 190 e" -w "^Ready;"

# Add the requred change to the top of each file
herccontrol "/edit DMSABN AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC404DS V01 NUCEXT and SUBCOM support"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSCSF AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC404DS V01 NUCEXT and SUBCOM support"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSFNC AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC404DS V01 NUCEXT and SUBCOM support"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSINS AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC404DS V01 NUCEXT and SUBCOM support"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSINT AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC404DS V01 NUCEXT and SUBCOM support"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSITS AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC404DS V01 NUCEXT and SUBCOM support"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSNUC AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC404DS V01 NUCEXT and SUBCOM support"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSNXD AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC404DS V01 NUCEXT and SUBCOM support"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSNXM AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC404DS V01 NUCEXT and SUBCOM support"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSSCN AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC404DS V01 NUCEXT and SUBCOM support"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSSNX AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC404DS V01 NUCEXT and SUBCOM support"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit NUCEXT AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC404DS V01 NUCEXT and SUBCOM support"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit NUCON AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC404DS V01 NUCEXT and SUBCOM support"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit SCBLOCK AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC404DS V01 NUCEXT and SUBCOM support"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit SHVBLOCK AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC404DS V01 NUCEXT and SUBCOM support"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit SUBCOM AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC404DS V01 NUCEXT and SUBCOM support"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

# Add New MACROs to library list CMSHRC EXEC B
herccontrol "/edit CMSHRC EXEC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/&1 &2 NUCEXT   MACRO"
herccontrol "/&1 &2 SUBCOM   MACRO"
herccontrol "/&1 &2 SCBLOCK  MACRO"
herccontrol "/&1 &2 SHVBLOCK MACRO"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

# Update the CMSLOAD EXEC file
herccontrol "/edit CMSLOAD EXEC E (nodisp" -w "^EDIT:"
herccontrol "//DMSTIO"
herccontrol "/input" -w "^INPUT:"
herccontrol "/&1 &2 &3 DMSSNX"
herccontrol "/&1 &2 &3 DMSCSF"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

# Install Mod
herccontrol "/installa" -w "^Ready;"
herccontrol "/erase installa exec a" -w "^Ready;"
