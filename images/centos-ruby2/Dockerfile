FROM hansode/centos-6.5-x86_64
RUN yum install -y gcc openssl-devel git tar && yum clean all
RUN git clone https://github.com/sstephenson/ruby-build.git /opt/ruby-build && cd /opt/ruby-build && ./install.sh
RUN git clone https://github.com/sstephenson/rbenv.git /opt/rbenv && cd /opt/rbenv && export ver=$(bin/rbenv install -l | grep -P "2.0.0-p\d+" | tail -n1) && bin/rbenv install $ver && bin/rbenv global $ver
ADD ./prepare /opt/openshift/
ADD ./start /opt/openshift/
RUN /opt/openshift/start gem install bundler --no-rdoc --no-ri
WORKDIR /opt/openshift/cartridge/
CMD /opt/openshift/start bundle exec rackup
