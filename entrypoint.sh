#!/bin/sh

set +e

# Ensure clean start
rm -rf /backup/*
# Download backup
s3cmd --region=${AWS_REGION} --progress get "s3://${S3_BUCKET}/${BACKUP_PATH}${BACKUP_NAME}" "/backup/${BACKUP_NAME}"
# Decompress backup with progress
cd /backup/ && pv $BACKUP_NAME | tar xzf - -C .

# Find where backups were extracted
DUMP_DIR=$(find /backup -name '*.bson' -print0 | xargs -0 -n1 dirname | head -1)

# Use dryRun to wait until mongo comes online
if [ "${MONGORESTORE_WAIT}" = true ] ; then
  cmd="mongorestore --verbose --dryRun --uri=${MONGO_URI} ${DUMP_DIR}"
  echo $cmd
  eval $cmd
fi

# Run restore
cmd="mongorestore ${MONGO_OPTIONS} --db=${MONGO_DB} --uri=${MONGO_URI} ${DUMP_DIR}"
echo $cmd
eval $cmd

# Delete backup files
rm -rf /backup/*

# Hang infinitely until stopped externally
if [ "${MONGORESTORE_HANG}" = true ] ; then
  while true
  do
    sleep 60
  done
fi
