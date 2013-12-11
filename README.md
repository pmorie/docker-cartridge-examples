docker-cartridge-examples
=========================

This repository contains example cartridges and prototyping for Docker based cartridges in OpenShift.  For more information about the design and implementation, see the [Docker cartridges PEP](https://github.com/openshift/openshift-pep/blob/master/openshift-pep-010-docker-cartridges.md).

The <code>images</code> directory contains a number of example "cartridges" which are simply a Dockerfile (representing the base cartridge) and a <code>cartridge.sh</code> script that represents a possible workflow of:

1. Build the cartridge into an image
2. "Prepare" the cartridge by injecting the source repo and invoking a script to build/deploy the source
3. Save that image as the **gear image**, suitable for deployment
4. Start the image

There are several ruby examples - Ruby 1.8.7 and 2.0.0 on CentOS, and then a Heroku Ruby Buildpack example.  Each of these uses the same source repository and provides the same running Ruby Rack application - but under the covers they're all doing different things to make that possible, and each can offer unique advantages.

Future steps are to do even more examples, and then start boiling all the metadata required into a manifest that can be converted to a Dockerfile for the script.
