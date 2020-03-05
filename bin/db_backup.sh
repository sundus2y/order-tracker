#!/bin/bash
# Get docker container id for ots_db
ots_db_container_id=$(docker ps -qf ancestor=ots_db)
# Print Container ID
echo "Container ID:"$ots_db_container_id

# Run backup task
echo "Run backup task . . ."
#docker exec -t $ots_db_container_id pg_dumpall -c -U postgres > /media/ots/Backup/DB/backup_`date +%d-%m-%Y"_"%H_%M_%S`.sql
docker exec -t $ots_db_container_id pg_dump -Fc --no-acl --no-owner -U postgres ots_prod > /media/ots/Backup/DB/backup_`date +%Y-%m-%d`.dump
echo "Backup completed"

# Upload to s3 once a week on Sunday
if [[ $(date +%u) -gt 1 ]] ; then
echo "Uploading to s3 . . ."
/usr/local/bin/aws s3 cp /media/ots/Backup/DB/backup_`date +%Y-%m-%d`.dump s3://sundus/OTS/Backups/
echo "Upload completed"
fi