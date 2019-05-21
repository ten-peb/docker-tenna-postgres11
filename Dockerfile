FROM tenna/ubuntu:latest
MAINTAINER  Peter L. Berghold <pberghold@tenna.com>
LABEL       com.tenna.vendor Tenna LLC
LABEL       com.tenna.app.postgresql.version 11.3
LABEL       com.tenna.app.author.email pberghold@tenna.com
LABEL       com.tenna.app.author.email2 peter@berghold.net
LABEL       com.tenna.docker.image.version 1.0.0

#
#   Grab what we need to build this image.  We'll clean up later
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get -y install build-essential make gcc g++ flex bison \
	wget curl libreadline-dev libreadline5 libzstd1 libzstd1-dev \
	zlib1g zlib1g-dev libsystemd-dev openssl libssl-dev libssl1.1

# create a working directory to build PostgreSQL 11 in

RUN     mkdir -vp /opt/pg  && \
        mkdir /tmp/workbench

# Pull the source code, configure the project, build it and install it. 
RUN     cd /tmp/workbench  && \
	wget --quiet \-O -  \
	https://ftp.postgresql.org/pub/source/v11.3/postgresql-11.3.tar.gz \
	| tar xvzf - \
	&& cd postgresql-11.3 \
	&& ./configure --prefix=/opt/pg  --with-systemd  --with-openssl \
	&& make \
	&& make install

# Create the postgresql userid 
RUN    useradd --system  \
	--home /var/lib/pgsql postgres && \
	mkdir -vp /var/lib/pgsql/data && \
	chown -R postgres /var/lib/pgsql && \
	su postgres -c '/opt/pg/bin/initdb /var/lib/pgsql/data '

# Copy the init script for postgresql into the /etc/init.d directory
COPY initscript.sh /etc/init.d/postgresql
RUN  chmod 755 /etc/init.d/postgresql

# Future systemd integration
COPY postgresql.service /etc/systemd/system/postgresql.service

# Copy our entrypoint 
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN  chmod 755 /docker-entrypoint.sh 


# Port to connect to
EXPOSE 5432

# Clean up anything we don't need to run Postgres with
RUN rm -rf /tmp/workbench && \
	apt -y autoremove && \
	apt-get -y clean && \
	rm -rf /var/lib/apt/lists/* && \
	apt-get -y remove make gcc g++ flex bison \
	wget curl libzstd1-dev \
	zlib1g-dev libsystemd-dev libssl-dev 

# Point to our entrypoint script
ENTRYPOINT /docker-entrypoint.sh 
