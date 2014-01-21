FROM mattdm/fedora:latest
RUN mkdir /opt/openshift
RUN groupadd -r openshift_mock -g 433 && \
useradd -u 431 -r -g openshift_mock -d /opt/openshift -s /sbin/nologin -c "mock cartridge user" openshift_mock
RUN chown openshift_mock /opt/openshift
RUN yum install -y ruby-devel rubygems gcc openssl-devel && yum clean all
RUN gem install webrick
USER openshift_mock
ADD ./mock_server.rb /opt/openshift/
WORKDIR /opt/openshift/
CMD cp -ad /tmp/repo /opt/openshift/repo