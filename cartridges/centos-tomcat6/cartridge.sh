#!/bin/sh
set -e

#
# A Tomcat6/CentOS cartridge that takes a WAR as input
#

rm -f built_cid

# Build the cartridge definition into an image
docker build -t smarterclayton/centos-tomcat6 .

curl -o ../../test_repos/tomcat6/sample.war http://tomcat.apache.org/tomcat-6.0-doc/appdev/sample/sample.war

# Given a source test repository, invoke the cartridge's prepare script on it
docker run -cidfile built_cid -i -v $(readlink -m ../../test_repos/tomcat6):/tmp/repo:ro smarterclayton/centos-tomcat6 /opt/openshift/prepare /tmp/repo

# Save the prepared cartridge as a deployment artifact (image representing runtime)
# Note: the cmd is being changed because of the "prepare" step being run above. Possibly
#       fixable with ENTRYPOINT
cid=$(cat built_cid)
docker commit -run='{"WorkingDir": "/opt/openshift/cartridge", "Cmd":  ["/bin/sh", "-c", "CATALINA_BASE=/usr/share/tomcat6 CATALINA_HOME=/usr/share/tomcat6 /opt/tomcat6/tomcat6"], "PortSpecs": ["8080"]}' $cid smarterclayton/centos-tomcat6-code

# Run the deployment artifact
docker run -p 8080 smarterclayton/centos-tomcat6-code
