FROM hansode/centos-6.5-x86_64
RUN mkdir /opt/openshift
RUN groupadd -r ruby_app -g 433 && \
useradd -u 431 -r -g ruby_app -d /opt/openshift -s /sbin/nologin -c "ruby cartridge user" ruby_app
RUN chown ruby_app /opt/openshift
RUN yum install -y gcc openssl-devel git tar && yum clean all
RUN git clone https://github.com/sstephenson/ruby-build.git /opt/ruby-build && cd /opt/ruby-build && ./install.sh
RUN git clone https://github.com/sstephenson/rbenv.git /opt/rbenv && cd /opt/rbenv && export ver=$(bin/rbenv install -l | grep -P "2.0.0-p\d+" | tail -n1) && bin/rbenv install $ver && bin/rbenv global $ver
USER ruby_app
ADD ./prepare /opt/openshift/
ADD ./start /opt/openshift/
RUN mkdir /opt/openshift/bundle && chown ruby_app /opt/openshift/bundle
RUN cd /opt/openshift && /opt/openshift/start gem install bundler --no-rdoc --no-ri
CMD /opt/openshift/start /opt/openshift/prepare /tmp/repo
