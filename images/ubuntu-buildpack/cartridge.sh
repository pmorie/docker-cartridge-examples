#!/bin/sh
set -e

#
# An Ubuntu Buildpack cartridge that takes a Ruby source repo and buildpack
#
# Note that the default Heroku buildpack timeout is 20s, this may be too short
# if you are not running in S3.  You can edit
#
#  ./cache/packs/70f57bb7858100f3aef58beafcc0dbe3/lib/language_pack/fetcher.rb
#
# to set the timeout higher.
#

rm -f built_cid

# Build the cartridge definition into an image
docker build -rm -t smarterclayton/ubuntu-buildpack .

# Given a source test repository, invoke the cartridge's prepare script on it (buildpack)
docker run -cidfile built_cid -i \
  -v $(readlink -m ../../test_repos/rackup):/tmp/repo:ro \
  -v $(readlink -m ./cache):/tmp/cache \
  -e 'BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-ruby.git' \
  smarterclayton/ubuntu-buildpack \
  /opt/openshift/buildpack /tmp/repo

# Save the prepared cartridge as a deployment artifact (image representing runtime)
# Note: the cmd is being changed because of the "prepare" step being run above. Possibly
#       fixable with ENTRYPOINT
cid=$(cat built_cid)
docker commit -run='{"WorkingDir": "/home/buildpack", "Cmd":  ["/opt/openshift/start"], "PortSpecs": ["5000"]}' $cid smarterclayton/ubuntu-buildpack-code

# Run the deployment artifact
docker run -rm -p 5000 smarterclayton/ubuntu-buildpack-code
