#!/bin/sh
# Fix PSLIST Mod (HRC309DS) installation
# Predicate - logged on as MAINT
#           - Needs buildnuc.sh run afterwards

# Exit if there is an error
set -e

# Access the CMS local modifications disk for write
herccontrol "/access 093 b" -w "^Ready;"

# Add the requred change to the top of each file
herccontrol "/edit DMSERS AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC309DS v03 EXEC now passes EPLIST when it calls CMS commands"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSINT AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC309DS v03 EXEC now passes EPLIST when it calls CMS commands"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSRNM AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC309DS v03 EXEC now passes EPLIST when it calls CMS commands"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

herccontrol "/edit DMSSTT AUXHRC B (nodisp" -w "^EDIT:"
herccontrol "/input" -w "^INPUT:"
herccontrol "/HRC309DS v03 EXEC now passes EPLIST when it calls CMS commands"
herccontrol "/" -w "^EDIT:"
herccontrol "/file" -w "^Ready;"

# Access MAINT's disks for building CMS components:
herccontrol "/CMSACC" -w "^Ready;"

# Assemble each of the four files:
herccontrol "/VMFASM DMSERS DMSHRC" -w "^Ready;"
herccontrol "/VMFASM DMSINT DMSHRC" -w "^Ready;"
herccontrol "/VMFASM DMSRNM DMSHRC" -w "^Ready;"
herccontrol "/VMFASM DMSSTT DMSHRC" -w "^Ready;"

# Generate a new RENAME MODULE
herccontrol "/CMSGEND RENAME NOINV" -w "^Ready;"

# Reaccess the disks for write
herccontrol "/access 093 b" -w "^Ready;"
herccontrol "/access 190 e" -w "^Ready;"

# Place the four newly created text decks and module to the required locations
herccontrol "/RENAME DMSERS TEXT B = TXTOLD B0" -w "^Ready;"
herccontrol "/COPYFILE DMSERS TEXT A = = B (OLDDATE" -w "^Ready;"
herccontrol "/ERASE DMSERS TXTOLD E" -w "^Ready;"
herccontrol "/RENAME DMSERS TEXT E = TXTOLD E0" -w "^Ready;"
herccontrol "/COPYFILE DMSERS TEXT A = = E (OLDDATE" -w "^Ready;"
herccontrol "/ERASE DMSERS TEXT A" -w "^Ready;"

herccontrol "/RENAME DMSINT TEXT B = TXTOLD B0" -w "^Ready;"
herccontrol "/COPYFILE DMSINT TEXT A = = B (OLDDATE" -w "^Ready;"
herccontrol "/ERASE DMSINT TXTOLD E" -w "^Ready;"
herccontrol "/RENAME DMSINT TEXT E = TXTOLD E0" -w "^Ready;"
herccontrol "/COPYFILE DMSINT TEXT A = = E (OLDDATE" -w "^Ready;"
herccontrol "/ERASE DMSINT TEXT A" -w "^Ready;"

herccontrol "/RENAME DMSRNM TEXT B = TXTOLD B0" -w "^Ready;"
herccontrol "/COPYFILE DMSRNM TEXT A = = B (OLDDATE" -w "^Ready;"
herccontrol "/ERASE DMSRNM TXTOLD E" -w "^Ready;"
herccontrol "/RENAME DMSRNM TEXT E = TXTOLD E0" -w "^Ready;"
herccontrol "/COPYFILE DMSRNM TEXT A = = E (OLDDATE" -w "^Ready;"
herccontrol "/ERASE DMSRNM TEXT A" -w "^Ready;"

herccontrol "/RENAME DMSSTT TEXT B = TXTOLD B0" -w "^Ready;"
herccontrol "/COPYFILE DMSSTT TEXT A = = B (OLDDATE" -w "^Ready;"
herccontrol "/ERASE DMSSTT TXTOLD E" -w "^Ready;"
herccontrol "/RENAME DMSSTT TEXT E = TXTOLD E0" -w "^Ready;"
herccontrol "/COPYFILE DMSSTT TEXT A = = E (OLDDATE" -w "^Ready;"
herccontrol "/ERASE DMSSTT TEXT A" -w "^Ready;"

herccontrol "/ERASE RENAME MODOLD E" -w "^Ready;"
herccontrol "/RENAME RENAME MODULE E = MODOLD E1" -w "^Ready;"
herccontrol "/COPYFILE RENAME MODULE A = = E2 (OLDDATE" -w "^Ready;"
herccontrol "/ERASE RENAME MODULE A" -w "^Ready;"
