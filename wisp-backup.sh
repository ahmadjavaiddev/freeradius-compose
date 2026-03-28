#!/bin/bash

# Move to the project directory
cd ~/freeradius-compose

# Load variables from your .env file
set -a
source .env
set +a

TIMESTAMP=$(date +"%Y-%m-%dT%H-%M-%S")
BACKUP_FILENAME="wisp-full-backup-$TIMESTAMP.tar.gz"

echo "1. Exporting PostgreSQL Database..."
# Tell the database container to create a clean SQL dump on the host machine
docker exec freeradius_db pg_dump -U ${DB_USER:-radius} -d ${DB_NAME:-radius} --clean > database.sql

echo "2. Zipping Database and WireGuard Keys..."
# Zip the new database.sql AND your wireguard config folder together
tar -czf $BACKUP_FILENAME database.sql ./wireguard/config

echo "3. Uploading to Cloudflare R2..."
# Spin up a temporary, official AWS CLI container just to upload the file, then delete itself
docker run --rm -v $(pwd):/workspace -w /workspace \
  -e AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY \
  -e AWS_SECRET_ACCESS_KEY=$S3_SECRET_KEY \
  -e AWS_DEFAULT_REGION=auto \
  amazon/aws-cli:latest \
  --endpoint-url $S3_ENDPOINT \
  s3 cp $BACKUP_FILENAME s3://$S3_BUCKET_NAME/

echo "4. Cleaning up local temporary files..."
rm database.sql
rm $BACKUP_FILENAME

echo "Backup Complete!"