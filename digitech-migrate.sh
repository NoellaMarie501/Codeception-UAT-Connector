#!/usr/bin/env bash
echo "Reading env parameters"
source variables.env

echo "Baselining db"
docker run --net="host" --rm boxfuse/flyway -schemas=$MYSQL_DATABASE -user=root -password=$MYSQL_ROOT_PASSWORD -url="jdbc:mysql://$1:$2?serverTimezone=UTC&useSSL=false" baseline

echo "Migrating database"
docker run --net="host" -v "$PWD/migrations:/flyway/sql" --rm boxfuse/flyway -schemas=$MYSQL_DATABASE -user=root -password=$MYSQL_ROOT_PASSWORD  -url="jdbc:mysql://$1:$2?serverTimezone=UTC&useSSL=false"  migrate