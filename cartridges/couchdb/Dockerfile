FROM shykes/couchdb
ADD ./launch /var/lib/couchdb/
RUN chown couchdb /var/lib/couchdb/launch
RUN chmod +x /var/lib/couchdb/launch
USER couchdb