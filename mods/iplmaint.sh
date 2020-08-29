#!/bin/sh
# IPL and login as MAINT

# Exit if there is an error
set -e

herccontrol "ipl 141" -w "USER DSC LOGOFF AS AUTOLOG1"
herccontrol "/cp start c" -w "RDR"
herccontrol "/cp disc" -w "^VM/370 Online"
herccontrol "/logon maint cpcms" -w "^CMS VERSION"
herccontrol "/" -w "^Ready"
herccontrol "/SET EMSG ON" -w "^Ready"
