FROM mattdm/fedora:f20
RUN yum install -y wildfly && yum clean all
ADD ./prepare /opt/openshift/
ADD ./launch /opt/openshift/