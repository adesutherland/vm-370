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

# Start Hercules
hercules -f hercules.conf -d >/dev/null 2>/dev/null &

# YATA UBUNTU v 1.2.0
wget -nv https://github.com/adesutherland/yata/releases/download/v1.2.0/YATA-Ubuntu.zip
unzip YATA-Ubuntu.zip
chmod +x YATA-Ubuntu/yata
cp YATA-Ubuntu/yata /usr/local/bin
rm -r YATA-Ubuntu
rm YATA-Ubuntu.zip

# YATA CMS v 1.2.0
wget -nv https://github.com/adesutherland/yata/releases/download/v1.2.0/YATA-CMS.zip
unzip YATA-CMS.zip
chmod +x YATA-CMS/cmsinstall.sh
mkdir io
cp YATA-CMS/* io
cd io
./cmsinstall.sh
cd ..
rm -r io
rm -r YATA-CMS
rm YATA-CMS.zip

# Apply VM/370 Mods
cd mods

cd hrc309ds
chmod +x *.sh
../iplmaint.sh
./hrc309ds.sh
../buildnuc.sh
../shutdown.sh
cd ..

cd hrc400ds
chmod +x *.sh
../iplmaint.sh
./part_a.sh
../buildnuc.sh
../shutdown.sh
../iplmaint.sh
./part_b.sh
../regen.sh
../shutdown.sh
cd ..

cd ..

# GCCLIB (0.7.10)
wget -nv https://github.com/adesutherland/CMS-370-GCCLIB/releases/download/v0.7.10/GCCLIB.zip
unzip GCCLIB.zip
chmod +x GCCLIB/cmsinstall.sh
mkdir io
cp GCCLIB/* io
cd io
./cmsinstall.sh
cd ..
rm -r io
rm -r GCCLIB
rm GCCLIB.zip

# CMS BREXX (0.9.3)
wget -nv https://github.com/adesutherland/CMS-370-BREXX/releases/download/v0.9.3/BREXX.zip
unzip BREXX.zip
chmod +x BREXX/cmsinstall.sh
mkdir io
cp BREXX/* io
cd io
./cmsinstall.sh
cd ..
rm -r io
rm -r BREXX
rm BREXX.zip

# Run sanity test
herccontrol "ipl 141" -w "USER DSC LOGOFF AS AUTOLOG1"
herccontrol "/cp disc" -w "^VM/370 Online"
herccontrol "/logon cmsuser cmsuser" -w "^CMS VERSION"
herccontrol "/" -w "^Ready"
herccontrol "/listf * * a" -w "^Ready"
herccontrol "/exectrac" -w "^Ready"
herccontrol "/logoff" -w "^VM/370 Online"
herccontrol "/logon operator operator" -w "RECONNECTED AT"
herccontrol "/shutdown" -w "^HHCCP011I"
herccontrol "exit"

# Compress disks
hercules -f hercules.conf -d >/dev/null 2>/dev/null &
herccontrol "sfc*"
herccontrol "sfk* 3"

herccontrol "exit"
