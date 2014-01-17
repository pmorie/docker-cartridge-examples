FROM ubuntu

RUN mkdir /home/buildpack
RUN groupadd -r buildpack_app -g 433 && \
useradd -u 431 -r -g buildpack_app -d /home/buildpack -s /sbin/nologin -c "buildpack cartridge user" buildpack_app
RUN chown buildpack_app /home/buildpack

RUN apt-get update
RUN apt-get -y install apt-utils git-core

# Simple ruby package support
RUN apt-get -y install ruby1.9.1 ruby1.9.1-dev rubygems1.9.1 irb1.9.1 build-essential libopenssl-ruby1.9.1 libssl-dev zlib1g-dev
RUN apt-get -y install curl

# ubuntu latest is on libssl1.0.0, Heroku Ruby depends on 0.9.8
RUN curl http://security.ubuntu.com/ubuntu/pool/universe/o/openssl098/libssl0.9.8_0.9.8o-7ubuntu3.1_amd64.deb -o libssl0.9.8_0.9.8o-7ubuntu3.1_amd64.deb && dpkg -i libssl0.9.8_0.9.8o-7ubuntu3.1_amd64.deb

# Heroku uses Foreman and Procfiles to control processes
RUN GEM_HOME=/home/buildpack gem install foreman --no-ri --no-rdoc

ADD ./buildpack /opt/openshift/
ADD ./start /opt/openshift/
