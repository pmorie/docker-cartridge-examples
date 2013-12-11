FROM hansode/centos-6.5-x86_64
RUN yum install -y tomcat6 && yum clean all && mkdir -p /opt/tomcat6/logs
ADD ./prepare /opt/openshift/
ADD ./tomcat6 /opt/tomcat6/
WORKDIR /opt/openshift/cartridge/
CMD CATALINA_BASE=/usr/share/tomcat6 CATALINA_HOME=/usr/share/tomcat6 /opt/tomcat6/tomcat6
