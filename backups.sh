#!/bin/bash

echo "Starting..."

echo "Configuring .s3cfg..."
envsubst < /backups/.s3cfg.sample > /backups/.s3cfg

echo "Configuring .pgpass..."
echo "$PGHOST:$PGPORT:$PGDB:$PGUSER:$PGPASSWORD" > .pgpass
chmod 600 .pgpass

echo "Dumping database..."
filename=`date +%Y-%m-%d_%H-%M-%S`_UTC_$PGDB.dump
pg_dump -Fc --verbose $PGDB > $filename

echo "Compressing dump..."
tar -zcf $filename.tar.gz $filename

echo "Uploading backup..."
s3cmd put $filename.tar.gz $DO_SPACES_UPLOAD_PATH

echo "Finished."
