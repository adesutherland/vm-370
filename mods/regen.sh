#!/bin/sh
# Rebuild / Regen CMS
# Predicate: logged on as MAINT

# Exit if there is an error
set -e

# Regenerate System
herccontrol "/define storage 16m"  -w "CP ENTERED"
herccontrol "/ipl 190" -w "^CMS VERSION"
herccontrol "/access ( noprof" -w "^Ready;"
herccontrol "/access 093 b" -w "^Ready;"
herccontrol "/access 193 c" -w "^Ready;"
herccontrol "/cmsxgen f00000 cmsseg" -w "^Ready;"
herccontrol "/ipl 190" -w "^CMS VERSION"
herccontrol "/savesys cms" -w "^CMS VERSION"
herccontrol "/" -w "^Ready;"
