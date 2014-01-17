docker-cartridge-examples
=========================

This repository contains example cartridges and prototyping for Docker based cartridges in OpenShift.
For more information about the design and implementation, see the 
[Docker cartridges PEP](https://github.com/openshift/openshift-pep/blob/master/openshift-pep-010-docker-cartridges.md).

The <code>platform</code> directory contains a simple proof of concept implementation of a build
system which creates runnable Docker images from cartridge 'manifests' and source code for an app.
The <code>cartridges</code> directory contains the Dockerfiles and manifests of several example 
cartridges:

1. `fedora-wildfly` and its builder `fedora-wildfly-build`
1. `ubuntu-buildpack`
1. `fedora-mock`
1. `centos-ruby2`

### Building

You can build a base image for a cartridge using the `build` command:

    sudo ./build <cartridge-name>

### Preparing a gear image

Once your cartridge image is built, you can prepare a gear image using the `prepare` command:

    sudo ./prepare <username> <cartridge-name> <path to source>

This will create a gear image with the tag `<username>/<cartridge-name>-app`.

### Running a gear image

You can run a gear image with the `run` command:

    sudo ./run <username> <app-name> <cartridge-name>

This will run the gear image with the required ports bound to dynamically allocated ports on the host
machine.

### Earlier R&amp;D

The <code>cartridges</code> directory also contains a number of preliminary example "cartridges" 
which are simply a Dockerfile (representing the base cartridge) and a <code>cartridge.sh</code>
script that pre-date the POC prepare script.  They implement the following workflow:

1. Build the cartridge into an image
2. "Prepare" the cartridge by injecting the source and invoking a script to build/deploy the 
source
3. Save that image as the **gear image**, suitable for deployment
4. Start the image

There are several ruby examples - Ruby 1.8.7 and 2.0.0 on CentOS, and then a Heroku Ruby Buildpack 
example.  Each of these uses the same source and provides the same running Ruby Rack 
application - but under the covers they're all doing different things to make that possible, and
each can offer unique advantages.
