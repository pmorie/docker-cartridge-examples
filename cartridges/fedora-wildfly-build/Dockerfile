FROM openshift/fedora-wildfly
RUN yum install -y java-devel maven && yum clean all
ADD ./build /opt/openshift/
