FROM goldmann/f20
RUN yum install -y wildfly && yum clean all
RUN yum install -y --enablerepo=updates-testing hibernate-4.3.0-0.6.Beta4.fc20
ADD ./prepare /opt/openshift/
RUN chmod +x /opt/openshift/prepare
ADD ./launch /opt/openshift/
RUN chmod +x /opt/openshift/launch
RUN /usr/share/wildfly/bin/add-user.sh admin Admin#70365 --silent
