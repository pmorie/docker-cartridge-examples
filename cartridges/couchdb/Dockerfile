FROM shykes/couchdb
ADD ./default.ini /etc/couchdb/default.ini
RUN chown couchdb /etc/couchdb/default.ini
ADD ./launch /var/lib/couchdb/
RUN chown couchdb /var/lib/couchdb/launch
RUN chmod +x /var/lib/couchdb/launch
ADD ./prepare /var/lib/couchdb/
RUN chown couchdb /var/lib/couchdb/prepare
RUN chmod +x /var/lib/couchdb/prepare
USER couchdb