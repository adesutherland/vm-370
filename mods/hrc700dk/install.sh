#!/bin/sh
# HRC700DK Mod - Contributed by Bob Bolch
# Predicate - logged on as MAINT
#           - Needs buildcp.sh run afterwards
## NOTE: CP MOD ##

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

# Access the CP modifications disk for write (and mods A -> C)
herccontrol "/access 094 a" -w "^Ready;"
herccontrol "/access 191 c" -w "^Ready;"

# Add the requred change to the top of each file
herccontrol "/edit DMKHVD AUXHRC A (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC700DK V01 Support for DIAG00 to return timezone offset"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

# Install Mod
herccontrol "/install" -w "^Ready;"
herccontrol "/erase install exec c" -w "^Ready;"
