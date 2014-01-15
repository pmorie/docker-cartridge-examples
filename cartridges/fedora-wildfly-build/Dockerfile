FROM openshift/fedora-wildfly
RUN yum install -y java-devel maven && yum clean all
RUN yum install -y --enablerepo=updates-testing hibernate-4.3.0-0.6.Beta4.fc20
ADD ./build /opt/openshift/
