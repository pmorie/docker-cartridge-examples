#!/bin/sh
set -e

#
# A Fedora MariaDB cartridge.
#
#   The prepare script can demonstrate how the Git repo could transfer a config
#     file to the image.
#   The start script handles generating the database in a persistent volume for
#     each use.
#
#   Since each database should have its own unique password, some form of
#   specialization is needed.  In this case, the start script is responsible
#   for a full initialization of the database.
#

rm -f built_cid

# Build the cartridge definition into an image
docker build -rm -t smarterclayton/fedora-mariadb .

# Given a source test repository, invoke the cartridge's prepare script on it
#docker run -cidfile built_cid -i -v $(readlink -m ../../test_repos/rackup):/tmp/repo:ro smarterclayton/fedora-mariadb /opt/openshift/prepare /tmp/repo

# Save the prepared cartridge as a deployment artifact (image representing runtime)
# The CMD and Port are reused from the Dockerfile - the prepare step is changing the value
# and so we must reset it.
#cid=$(cat built_cid)
#docker commit -run='{"WorkingDir": "/opt/openshift/cartridge", "Cmd": ["/usr/sbin/mysqld"], "PortSpecs": ["3306"]}' $cid smarterclayton/fedora-mariadb-code

# Run the deployment artifact
#
# WARNING: The user that must own both of the mount points must be "mysql", but Docker is the only
#   one who knows what the user id will be.  On mount, we need a way to chown the base directories
#   to the correct directory prior to startup (since mysqld needs to write to those directories).
#
echo "You must chown data and logs to the container uid/gid before they are mounted"
docker run -v $(readlink -f ./data):/var/lib/mysql -v $(readlink -f ./logs):/var/log/mysql -rm -p 3306 smarterclayton/fedora-mariadb
