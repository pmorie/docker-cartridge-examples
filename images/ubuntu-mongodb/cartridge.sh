#!/bin/sh
set -e

#
# A MongoDB/Ubuntu cartridge without a prepare step
#

# Build the cartridge definition into an image (without prepare,
# this image becomes a deployment artifact directly).
docker build -t smarterclayton/ubuntu-mongodb .

# Run the deployment artifact
docker run -p 27017 smarterclayton/ubuntu-mongodb
