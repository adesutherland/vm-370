#!/bin/sh
# Start Hercules
mkdir io >/dev/null 2>/dev/null | true
hercules -f hercules.conf -d >/dev/null 2>/dev/null
