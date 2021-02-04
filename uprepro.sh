#!/bin/sh
# Script to update container repositories

TAG=1.4.31
# Docker Tagging (builder, test and latest)
docker pull adriansutherland/vm370:$TAG
docker tag adriansutherland/vm370:$TAG adriansutherland/vm370:builder
docker push adriansutherland/vm370:builder

docker pull adriansutherland/vm370:$TAG
docker tag adriansutherland/vm370:$TAG adriansutherland/vm370:test
docker push adriansutherland/vm370:test

docker pull adriansutherland/vm370:$TAG
docker tag adriansutherland/vm370:$TAG adriansutherland/vm370:latest
docker push adriansutherland/vm370:latest

# Upload Image to Google Cloud
# GCLOUD SDK needs to be installed, then linked to Docker Desktop
# gcloud auth configure-docker
docker pull adriansutherland/vm370:test
docker tag adriansutherland/vm370:test gcr.io/utility-ridge-243715/vm370:test
docker push gcr.io/utility-ridge-243715/vm370:test