#!/bin/sh
set -e

#
# A Wildfly cartridge.  Note that this is using the existing Wildfly
# image as is - it builds in the steps necessary to make it a cartridge
# (i.e. take as input a directory and process source or a WAR into
# something that is runnable).
#

rm -f built_cid

# Build the cartridge definition into an image
docker build -t smarterclayton/wildfly-standalone-cart .

# Download a sample WAR
curl -o ../../test_sources/tomcat6/sample.war http://tomcat.apache.org/tomcat-6.0-doc/appdev/sample/sample.war

# Given a source test repository, invoke the cartridge's prepare script on it
docker run -entrypoint '/opt/openshift/prepare' -cidfile built_cid -i -v $(readlink -m ../../test_sources/tomcat6):/tmp/repo:ro smarterclayton/wildfly-standalone-cart /tmp/repo

# Save the prepared cartridge as a deployment artifact (image representing runtime)
# The CMD and Port are reused from the Dockerfile - the prepare step is changing the value
# and so we must reset it.
cid=$(cat built_cid)
docker commit -run='{"Cmd": ["/launch.sh"], "PortSpecs": ["8080"]}' $cid smarterclayton/wildfly-standalone-cart-code

# Run the deployment artifact
docker run -p 8080 smarterclayton/wildfly-standalone-cart-code
