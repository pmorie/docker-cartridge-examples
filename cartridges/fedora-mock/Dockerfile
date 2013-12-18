FROM mattdm/fedora:latest
RUN yum install -y ruby-devel rubygems gcc openssl-devel && yum clean all
RUN gem install webrick
ADD ./mock_server.rb /opt/openshift/
WORKDIR /opt/openshift/
CMD cp -ad /tmp/repo /opt/openshift/repo
