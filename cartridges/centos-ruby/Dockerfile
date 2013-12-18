FROM hansode/centos-6.5-x86_64
RUN yum install -y ruby-devel rubygems gcc openssl-devel && yum clean all
RUN gem install -y bundler --no-ri --no-rdoc
ADD ./prepare /opt/openshift/
WORKDIR /opt/openshift/cartridge/
CMD bundle exec rackup
