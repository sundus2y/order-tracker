FROM schickling/postgres-backup-s3

ENV SCHEDULE '@daily'
ENV S3_REGION region
ENV S3_ACCESS_KEY_ID key
ENV S3_SECRET_ACCESS_KEY secret
ENV S3_BUCKET 'ots_backup/local'
ENV S3_PREFIX backup
ENV POSTGRES_DATABASE ots_prod
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD "P0$t9res!2019"
ENV POSTGRES_EXTRA_OPTS '--schema=public --blobs'
ENV SCHEDULE '@daily'