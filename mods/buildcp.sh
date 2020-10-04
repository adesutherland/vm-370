#!/bin/sh
# Rebuild / Regen CP
# Predicate: logged on as MAINT

# Exit if there is an error
set -e

# Access the CP modifications disk for write (and make A -> C)
herccontrol "/access 094 a" -w "^Ready;"
herccontrol "/access 191 c" -w "^Ready;"

# Build the nucleus:
herccontrol "/PURGE PRT" -w "^Ready;"
herccontrol "/PURGE PUN" -w "^Ready;"
herccontrol "/PURGE RDR" -w "^Ready;"
herccontrol "/SPOOL PRT *" -w "^Ready;"
herccontrol "/SPOOL PUN *" -w "^Ready;"
herccontrol "/VMFLOAD CPLOAD DMKHRC" -w "^Ready;"
herccontrol "/IPL 00C CLEAR" -w "CP ENTERED"
herccontrol "/IPL CMS" -w "CMS VERSION"
herccontrol "/" -w "^Ready"
herccontrol "/CLOSE RDR" -w "^Ready;"
herccontrol "/READCARD CPNUC MAP" -w "^Ready;"
