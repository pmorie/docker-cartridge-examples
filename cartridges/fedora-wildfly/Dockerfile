FROM goldmann/f20
RUN mkdir /opt/openshift
RUN groupadd -r wildfly_app -g 433 && \
useradd -u 431 -r -g wildfly_app -d /opt/openshift -s /sbin/nologin -c "wildfly app user" wildfly_app
RUN chown wildfly_app /opt/openshift
RUN chgrp wildfly_app /opt/openshift
RUN yum install -y wildfly && yum clean all
RUN yum install -y --enablerepo=updates-testing hibernate-4.3.0-0.6.Beta4.fc20
RUN chown wildfly_app /usr/share/wildfly
ADD ./prepare /opt/openshift/
RUN chown wildfly_app /opt/openshift/prepare
RUN chmod +x /opt/openshift/prepare
ADD ./launch /opt/openshift/
RUN chown wildfly_app /opt/openshift/launch
RUN chmod +x /opt/openshift/launch
RUN /usr/share/wildfly/bin/add-user.sh admin Admin#70365 --silent
