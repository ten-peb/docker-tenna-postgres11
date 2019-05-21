#!/bin/bash
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#
# File: docker-entrypoint.sh
#
# Purpose: Start the PostgreSQL application and loop until stopped
#
# Author: Peter L. Berghold <pberghold@tenna.com> or <peter@berghold.net>
#
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


# Make darn sure the PGDATA directory exists and has proper
# permissions/ownership
if [ ! -d /var/log/pg ]
then
    mkdir /var/log/pg
    chown -R postgres:postgres /var/log/pg 
fi


# Start the music
/etc/init.d/postgresql start 

# If the above falls through, loop until stopped so logs are still
# visible to the "docker logs" command
while /bin/true
do
    sleep 1500
done
