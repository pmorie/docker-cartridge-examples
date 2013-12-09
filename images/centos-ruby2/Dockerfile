FROM hansode/centos-6.5-x86_64
ADD ./prepare /opt/openshift/
RUN yum install -y gcc openssl-devel git tar && yum clean all
RUN git clone https://github.com/sstephenson/ruby-build.git /opt/ruby-build && cd /opt/ruby-build && ./install.sh
RUN git clone https://github.com/sstephenson/rbenv.git /opt/rbenv && cd /opt/rbenv && ./bin/rbenv install $(./bin/rbenv install -l | grep -P "2.0.0-p\d+" | tail -n1)
# Needs to set environment and create a helper to auto script it
WORKINGDIR /opt/openshift/cartridge/
CMD bundle exec rackup
