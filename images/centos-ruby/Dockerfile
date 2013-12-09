FROM hansode/centos-6.5-x86_64
ADD ./prepare /opt/openshift/
RUN yum install -y ruby-devel rubygems gcc openssl-devel && yum clean all
RUN gem install -y bundler --no-ri --no-rdoc
WORKINGDIR /opt/openshift/cartridge/
CMD bundle exec rackup
