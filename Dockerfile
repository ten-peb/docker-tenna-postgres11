FROM tenna/ubuntu:latest

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get -y install build-essential make gcc g++ flex bison \
	wget curl libreadline-dev libreadline5 libzstd1 libzstd1-dev \
	zlib1g zlib1g-dev libsystemd-dev openssl libssl-dev libssl1.1
RUN     mkdir -vp /opt/pg  && \
        mkdir /tmp/workbench
RUN     cd /tmp/workbench  && \
	wget --quiet \-O -  \
	https://ftp.postgresql.org/pub/source/v11.3/postgresql-11.3.tar.gz \
	| tar xvzf - \
	&& cd postgresql-11.3 \
	&& ./configure --prefix=/opt/pg  --with-systemd  --with-openssl \
	&& make \
	&& make install
RUN    useradd --system  \
	--home /var/lib/pgsql postgres && \
	mkdir -vp /var/lib/pgsql/data && \
	chown -R postgres /var/lib/pgsql && \
	su postgres -c '/opt/pg/bin/initdb /var/lib/pgsql/data '

COPY initscript.sh /etc/init.d/postgresql
RUN  chmod 755 /etc/init.d/postgresql

COPY postgresql.service /etc/systemd/system/postgresql.service

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN  chmod 755 /docker-entrypoint.sh 

COPY  start_postgres.sh /opt/pg/bin/start_postgres.sh
RUN  chmod 755 /opt/pg/bin/start_postgres.sh

EXPOSE 5432

RUN rm -rf /tmp/workbench && \
    apt-get -y clean

ENTRYPOINT /docker-entrypoint.sh 
