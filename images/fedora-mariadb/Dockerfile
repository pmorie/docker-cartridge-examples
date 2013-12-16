FROM mattdm/fedora:f19
RUN yum install -y mariadb mariadb-server && yum clean all
VOLUME /var/lib/mysql
VOLUME /var/log/mysql
ADD ./simple.cnf /etc/my.cnf.d/
ADD ./prepare /opt/openshift/
ADD ./start /opt/openshift/
USER mysql
CMD /opt/openshift/start
