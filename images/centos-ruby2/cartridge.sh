#!/bin/sh
set -e

#
# A Ruby/CentOS cartridge.
#

rm -f built_cid

# Build the cartridge definition into an image
docker build -t smarterclayton/centos-ruby2 .

# Given a source test repository, invoke the cartridge's prepare script on it
docker run -cidfile built_cid -i -v $(readlink -m ../../test_repos/rails):/tmp/repo:ro smarterclayton/centos-ruby2 /opt/openshift/start /opt/openshift/prepare /tmp/repo

# Save the prepared cartridge as a deployment artifact (image representing runtime)
cid=$(cat built_cid)
docker commit -run='{"WorkingDir": "/opt/openshift/cartridge", "Cmd": ["/opt/openshift/start", "bundle exec rackup"], "PortSpecs": ["9292"]}' $cid smarterclayton/centos-ruby2-code

# Run the deployment artifact
docker run -p 9292 smarterclayton/centos-ruby2-code
