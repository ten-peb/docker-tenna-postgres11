#!/bin/bash

if [ ! -d /var/log/pg ]
then
    mkdir /var/log/pg
    chown -R postgres:postgres /var/log/pg 
fi

#   su postgres -c /opt/pg/bin/start_postgres.sh
/etc/init.d/postgresql start 

while /bin/true
do
    sleep 1500
done
