#!/bin/sh
# Rebuild / Regen CMS
# Predicate: logged on as MAINT

# Exit if there is an error
set -e

# Access CMS Disks
herccontrol "/CMSACC" -w "^Ready;"

# Rebuild the CMS nucleus by following step 7 of the procedure in SYSPROG MEMO
herccontrol "/purge rdr" -w "^Ready;"
herccontrol "/vmfload cmsload dmshrc" -w "^Ready;"
herccontrol "/SPOOL 00C CLASS *" -w "^Ready;"

# herccontrol "/CP Q PUN ALL *" -w "^Ready;"
# herccontrol "/CP Q RDR ALL *" -w "^Ready;"
# herccontrol "/CP Q V 00C" -w "^Ready;"

herccontrol "/ipl 00c clear" -w "DMSINI606R"

# DMSINI606R SYSTEM DISK ADDRESS = 190
herccontrol "/190"

# DMSINI615R Y-DISK ADDRESS = 19e
herccontrol "/19e"

# DMSINI607R REWRITE THE NUCLEUS ? yes
herccontrol "/yes"

# DMSINI608R IPL DEVICE ADDRESS = 190
herccontrol "/190"

# DMSINI609R NUCLEUS CYL ADDRESS = 59
herccontrol "/59"

# DMSINI610R ALSO IPL CYLINDER 0 ? yes
herccontrol "/yes"

# DMSINI611R VERSION IDENTIFICATION =
herccontrol "/CMS VERSION 6.0 DOCKER 1.4.28"

# DMSINI612R INSTALLATION HEADING =
herccontrol "/Conversional Monitor System"

herccontrol "/" -w "^Ready;"

spool_id=$(herccontrol "/CP SPOOL 00E * CLOSE" -w "^PRT FILE" -s | awk '{print $3}')
herccontrol "/order reader $spool_id" -w "^Ready;"

# The RDR file seems to take a bit of time to become ready!
counter=0
while [ "$result" != "Ready" ]
do
 if [ "$counter" -gt 5 ]; then
     echo "ERROR: Gave up waiting for RDR!"
     exit 1
 fi
 counter=$((counter+1))
 result=$(herccontrol "/READ CMSLOAD MAP A (REPLACE" -w "^Ready" -s | awk '{sub(/;.*/, ""); print}')
 if [ "$result" != "Ready" ]; then
   sleep 1
 fi
done

herccontrol "/ipl 190 clear" -w "^CMS VERSION"
herccontrol "/savesys cms" -w "^CMS VERSION"
herccontrol "/" -w "^Ready;"
