#!/bin/sh
# Make Hercules Docker Distribution

# Exit of there is an error
set -e

# HercControl
wget -nv https://github.com/adesutherland/HercControl/releases/download/v1.1.0/HercControl-Ubuntu.zip
unzip HercControl-Ubuntu.zip
chmod +x HercControl-Ubuntu/herccontrol
cp HercControl-Ubuntu/herccontrol /usr/local/bin
rm -r HercControl-Ubuntu
rm HercControl-Ubuntu.zip

# Get the VM disks
wget -nv https://github.com/adesutherland/vm-370/releases/download/v1.3.4/vm370.zip
unzip vm370.zip
rm vm370.zip

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

# YATA - Ubuntu
wget -nv https://github.com/adesutherland/yata/releases/download/v1.1.2/YATA-Ubuntu.zip
unzip YATA-Ubuntu.zip
chmod +x YATA-Ubuntu/yata
cp YATA-Ubuntu/yata /usr/local/bin
rm -r YATA-Ubuntu
rm YATA-Ubuntu.zip

# YATA - CMS
wget -nv https://github.com/adesutherland/yata/releases/download/v1.1.2/YATA-CMS.zip
unzip YATA-CMS.zip
chmod +x YATA-CMS/cmsinstall.sh
mkdir io
cp YATA-CMS/cmsinstall.sh io
cp YATA-CMS/yatabin.aws io
cd io
./cmsinstall.sh
cd ..
rm -r io
rm -r YATA-CMS
rm YATA-CMS.zip

# Compress disks
# hercules -f hercules.conf -d >/dev/null 2>/dev/null &
herccontrol "sfc*" -w "HHCCD092I"
herccontrol "sfk* 3" -w "HHCCD092I"
herccontrol "exit"
