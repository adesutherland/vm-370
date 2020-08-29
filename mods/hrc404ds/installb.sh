#!/bin/sh
# HRC400DS Mod - Thanks to Bob Bolch!
# Predicate - logged on as MAINT
#           - Needs regen.sh run afterwards
#           - Needs EXECTRAC ASSMEBLE and INSTALLB EXEC
#           - to have been loaded on A drive
# PART B - The EXECTRAC tool

# Exit if there is an error
set -e

# Install Application
herccontrol "/installb" -w "^Ready;"
herccontrol "/erase installb exec a" -w "^Ready;"
