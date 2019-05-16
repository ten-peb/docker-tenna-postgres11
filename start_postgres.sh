#!/bin/bash

/opt/pg/bin/postgres -D /var/lib/pgsql/data \
		       2>&1 | tee /var/log/pg/postgresql.log
