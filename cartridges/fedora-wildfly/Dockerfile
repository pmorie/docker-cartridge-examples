FROM goldmann/f20
RUN yum install -y wildfly && yum clean all
RUN yum install -y --enablerepo=updates-testing hibernate-4.3.0-0.6.Beta4.fc20
ADD ./prepare /opt/openshift/
ADD ./launch /opt/openshift/