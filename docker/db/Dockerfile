FROM postgres:11.4

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD="P0$t9res!2019"
ENV POSTGRES_DB=ots_prod


RUN mkdir dumps
COPY ./docker/db/dumps/ots.dump /dumps
COPY ./docker/db/dumps/init.sql /docker-entrypoint-initdb.d/

EXPOSE 5432

#RUN psql -U postgres "ALTER ROLE postgres WITH PASSWORD 'P0$t9res!2019'"
