#!/bin/sh
# Script to run the locally built container
docker run -rm -d -p 3270:3270 -p 8038:8038 -p 3505:3505 --name vm370 adriansutherland/vm370local:latest