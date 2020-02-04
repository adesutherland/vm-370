#!/bin/sh
# Make Hercules Docker Distribution

# Exit of there is an error
set -e

# Get the disks
wget -nv https://github.com/adesutherland/vm-370/releases/download/v1.3.4/vm370.zip
unzip vm370.zip
rm vm370.zip

# Compress disks
hercules -f hercules.conf -d >/dev/null 2>/dev/null &
herccontrol "sfc*" -w "HHCCD092I"
herccontrol "sfk* 3" -w "HHCCD092I"
herccontrol "exit"

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
