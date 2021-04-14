#!/bin/sh
# Make Hercules Docker Distribution

# Exit if there is an error
set -e

# HercControl
wget -nv https://github.com/adesutherland/HercControl/releases/download/v1.1.0/HercControl-Ubuntu.zip
unzip HercControl-Ubuntu.zip
chmod +x HercControl-Ubuntu/herccontrol
cp HercControl-Ubuntu/herccontrol /usr/local/bin
rm -r HercControl-Ubuntu
rm HercControl-Ubuntu.zip

# Remove Shadow Files
hercules -f cleandisks.conf -d >/dev/null 2>/dev/null &
herccontrol "sf-* force" -w "HHCCD092I"
herccontrol "exit"

# Move Disks
mv ./disks/*.cckd .

# Start Hercules
(cd /opt/hercules/vm370; hercules -f hercules.conf -d >/dev/null 2>/dev/null &)

# YATA UBUNTU
wget -nv https://github.com/adesutherland/yata/releases/download/v1.2.5/YATA-Ubuntu.zip
unzip YATA-Ubuntu.zip
chmod +x YATA-Ubuntu/yata
cp YATA-Ubuntu/yata /usr/local/bin
rm -r YATA-Ubuntu
rm YATA-Ubuntu.zip

# Get latest gccbrx.cckd
herccontrol "detach 09F0"
wget -nv https://github.com/adesutherland/CMS-370-BREXX/releases/download/f0049.2/BREXX.zip
unzip BREXX.zip
cp BREXX/gccbrx.cckd .
rm BREXX.zip
rm -r BREXX
herccontrol "attach 09F0 3350 gccbrx.cckd"

# YATA CMS
wget -nv https://github.com/adesutherland/yata/releases/download/v1.2.5/YATA-CMS.zip
unzip YATA-CMS.zip
mkdir io
cp YATA-CMS/* io
cd io

# IPL
herccontrol "ipl 141" -w "USER DSC LOGOFF AS AUTOLOG1"

# LOGON MAINTC AND READ TAPE
herccontrol "/cp disc" -w "^VM/370 Online"
herccontrol "/logon maintc maintc" -w "^CMS"
herccontrol "/" -w "^Ready;"
herccontrol "devinit 480 io/yatabin.aws" -w "^HHCPN098I"
herccontrol "/cp disc" -w "^VM/370 Online"
herccontrol "/logon operator operator" -w "RECONNECTED AT"
herccontrol "/attach 480 to maintc as 181" -w "TAPE 480 ATTACH TO MAINT"
herccontrol "/cp disc" -w "^VM/370 Online"
herccontrol "/logon maintc maintc" -w "RECONNECTED"
herccontrol "/begin"
herccontrol "/tape load * * t" -w "^Ready;"
herccontrol "/detach 181" -w "^Ready;"
herccontrol "/yata -v" -w "^Ready;"
herccontrol "/logoff" -w "^VM/370 Online"

# REBUILD CMS
herccontrol "/logon maint cpcms" -w "^CMS"
herccontrol "/" -w "^Ready"
herccontrol "/NEWBREXX" -w "^Ready"
herccontrol "/define storage 16m"  -w "CP ENTERED"
herccontrol "/ipl 190 clear" -w "^CMS"
herccontrol "/savesys cms" -w "^CMS"
herccontrol "/" -w "^Ready;"
herccontrol "/logoff" -w "^VM/370 Online"

# SHUTDOWN
herccontrol "/logon operator operator" -w "RECONNECTED AT"
herccontrol "/shutdown" -w "^HHCCP011I"

# Remove temp YATA download
cd ..
rm -r io
rm -r YATA-CMS
rm YATA-CMS.zip

herccontrol "exit"
