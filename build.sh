#!/bin/sh
# Make Hercules Docker Distribution

# Exit of there is an error
set -e

# Unzip Sixpack
unzip -o -d sixpack vm370sixpack-1_3_Beta3.zip
rm vm370sixpack-1_3_Beta3.zip

# Remove Shadow Files
cd sixpack
rm hercules.rc # Don't want to IPL
echo "HTTPPORT 8038" >> sixpack.conf # Turn on the webconsole
hercules -f sixpack.conf -d >/dev/null 2>/dev/null &
herccontrol "sf-* force" -w "HHCCD092I"
herccontrol "exit"
cd ..

# Move Disks
mv sixpack/disks/vm3350-* .

# Compress disks
hercules -f hercules.conf -d >/dev/null 2>/dev/null &
herccontrol "sfc*" -w "HHCCD092I"
herccontrol "sfk* 3" -w "HHCCD092I"
herccontrol "exit"

# Erase the rest of the six pack
rm -r sixpack

# Run sanity test
hercules -f hercules.conf -d >/dev/null 2>/dev/null &
herccontrol "ipl 141" -w "USER DSC LOGOFF AS AUTOLOG1"
herccontrol "/cp disc" -w "^VM/370 Online"
herccontrol "/logon cmsuser cmsuser" -w "^CMS VERSION"
herccontrol "/" -w "^Ready"
herccontrol "/listf * * a" -w "^Ready"
herccontrol "/logoff" -w "^VM/370 Online"
herccontrol "/logon operator operator" -w "RECONNECTED AT"
herccontrol "/shutdown" -w "^HHCCP011I"
herccontrol "exit"
