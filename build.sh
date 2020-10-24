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
(cd /opt/hercules/vm370; hercules -f hercules.conf -d >/dev/null 2>/dev/null &)

# YATA UBUNTU
wget -nv https://github.com/adesutherland/yata/releases/download/v1.2.4/YATA-Ubuntu.zip
unzip YATA-Ubuntu.zip
chmod +x YATA-Ubuntu/yata
cp YATA-Ubuntu/yata /usr/local/bin
rm -r YATA-Ubuntu
rm YATA-Ubuntu.zip

# YATA CMS
wget -nv https://github.com/adesutherland/yata/releases/download/v1.2.4/YATA-CMS.zip
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

## Load a standalone version of BREXX for MAINT to load mods
## MNTREXX on MAINTs A Drive
#wget -nv https://github.com/adesutherland/CMS-370-BREXX/releases/download/f0020/BREXX.zip
#unzip BREXX.zip
#mkdir io
#cp BREXX/* io
#cd io
## IPL
#herccontrol "ipl 141" -w "USER DSC LOGOFF AS AUTOLOG1"
## LOGON MAINT AND READ TAPE
#herccontrol "/cp disc" -w "^VM/370 Online"
#herccontrol "/logon maint cpcms" -w "^CMS VERSION"
#herccontrol "/" -w "^Ready;"
#herccontrol "devinit 480 io/brexxbin.aws" -w "^HHCPN098I"
#herccontrol "/attach 480 to maint as 181" -w "TAPE 480 ATTACH"
## Load and rename BREXX at MNTREXX just for MAINT on A drive
#herccontrol "/tape load brexx module a" -w "^Ready;"
#herccontrol "/copy brexx module a mntrexx module a (replace" -w "^Ready;"
#herccontrol "/erase brexx module a" -w "^Ready;"
## Done with tape & logoff
#herccontrol "/detach 181" -w "^Ready;"
#herccontrol "/logoff" -w "^VM/370 Online"
## SHUTDOWN
#herccontrol "/logon operator operator" -w "RECONNECTED AT"
#herccontrol "/shutdown" -w "^HHCCP011I"
#herccontrol "exit"
## Clean up
#cd ..
#rm -r io
#rm -r BREXX
#rm BREXX.zip

# Apply VM/370 Mods
cd mods

# CP mods

cd hrc700dk
(cd /opt/hercules/vm370; hercules -f hercules.conf -d >/dev/null 2>/dev/null &)
dos2unix *.sh
chmod +x *.sh
../iplmaint.sh
./install.sh
../buildcp.sh
../shutdown.sh
herccontrol "exit"
cd ..

# CMS mods / utilities

cd hrc309ds
(cd /opt/hercules/vm370; hercules -f hercules.conf -d >/dev/null 2>/dev/null &)
dos2unix *.sh
chmod +x *.sh
../iplmaint.sh
./hrc309ds.sh
../buildnuc.sh
../shutdown.sh
herccontrol "exit"
cd ..

cd hrc400ds
(cd /opt/hercules/vm370; hercules -f hercules.conf -d >/dev/null 2>/dev/null &)
dos2unix *.sh
chmod +x *.sh
../iplmaint.sh
./installa.sh
../buildnuc.sh
../shutdown.sh
../iplmaint.sh
./installb.sh
../regen.sh
../shutdown.sh
herccontrol "exit"
cd ..

cd hrc402ds
(cd /opt/hercules/vm370; hercules -f hercules.conf -d >/dev/null 2>/dev/null &)
dos2unix *.sh
chmod +x *.sh
../iplmaint.sh
./install.sh
../buildnuc.sh
../shutdown.sh
herccontrol "exit"
cd ..

cd hrc403ds
(cd /opt/hercules/vm370; hercules -f hercules.conf -d >/dev/null 2>/dev/null &)
dos2unix *.sh
chmod +x *.sh
../iplmaint.sh
./install.sh
../buildnuc.sh
../shutdown.sh
herccontrol "exit"
cd ..

cd hrc404ds
(cd /opt/hercules/vm370; hercules -f hercules.conf -d >/dev/null 2>/dev/null &)
dos2unix *.sh
chmod +x *.sh
../iplmaint.sh
./installa.sh
../buildnuc.sh
../shutdown.sh
../iplmaint.sh
./installb.sh
../regen.sh
../shutdown.sh
herccontrol "exit"
cd ..

cd execio
(cd /opt/hercules/vm370; hercules -f hercules.conf -d >/dev/null 2>/dev/null &)
dos2unix *.sh
chmod +x *.sh
../iplmaint.sh
./install.sh
../regen.sh
../shutdown.sh
herccontrol "exit"
cd ..

cd hrc406ds
(cd /opt/hercules/vm370; hercules -f hercules.conf -d >/dev/null 2>/dev/null &)
dos2unix *.sh
chmod +x *.sh
../iplmaint.sh
./install.sh
../buildnuc.sh
../shutdown.sh
../iplmaint.sh
../regen.sh
../shutdown.sh
herccontrol "exit"
cd ..

cd hrc407ds
(cd /opt/hercules/vm370; hercules -f hercules.conf -d >/dev/null 2>/dev/null &)
dos2unix *.sh
chmod +x *.sh
../iplmaint.sh
./install.sh
../regen.sh
../shutdown.sh
herccontrol "exit"
cd ..

cd ..

# Now load packages

# GCCLIB
(cd /opt/hercules/vm370; hercules -f hercules.conf -d >/dev/null 2>/dev/null &)
wget -nv https://github.com/adesutherland/CMS-370-GCCLIB/releases/download/v0.8.0/GCCLIB.zip
unzip GCCLIB.zip
chmod +x GCCLIB/cmsinstall.sh
mkdir io
cp GCCLIB/* io
cd io
./cmsinstall.sh
cd ..
herccontrol "exit"
rm -r io
rm -r GCCLIB
rm GCCLIB.zip

# CMS BREXX
(cd /opt/hercules/vm370; hercules -f hercules.conf -d >/dev/null 2>/dev/null &)
wget -nv https://github.com/adesutherland/CMS-370-BREXX/releases/download/f0023/BREXX.zip
unzip BREXX.zip
chmod +x BREXX/cmsinstall.sh
mkdir io
cp BREXX/* io
cd io
./cmsinstall.sh
cd ..
herccontrol "exit"
rm -r io
rm -r BREXX
rm BREXX.zip

# Run sanity test
(cd /opt/hercules/vm370; hercules -f hercules.conf -d >/dev/null 2>/dev/null &)
herccontrol "ipl 141" -w "USER DSC LOGOFF AS AUTOLOG1"
herccontrol "/cp disc" -w "^VM/370 Online"
herccontrol "/logon cmsuser cmsuser" -w "^CMS VERSION"
herccontrol "/" -w "^Ready"
herccontrol "/listf * * a" -w "^Ready"
herccontrol "/logoff" -w "^VM/370 Online"
herccontrol "/logon operator operator" -w "RECONNECTED AT"
herccontrol "/shutdown" -w "^HHCCP011I"
herccontrol "exit"

# Compress disks
(cd /opt/hercules/vm370; hercules -f hercules.conf -d >/dev/null 2>/dev/null &)
herccontrol "sfc*"
herccontrol "sfk* 3"
herccontrol "exit"
