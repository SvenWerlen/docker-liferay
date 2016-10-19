#!/bin/bash

if [ -z "$DBHOST" ]; then
    echo "Please specify: -e DBHOST="
    exit 1
fi

if [ -z "$DBNAME" ]; then
    echo "Please specify: -e DBNAME="
    exit 1
fi

if [ -z "$DBUSER" ]; then
    echo "Please specify: -e DBUSER="
    exit 1
fi


export LIFERAY_HOME="/opt/app/liferay"
sed -i "s/DBHOST/${DBHOST}/g" $LIFERAY_HOME/portal-mysql.properties
sed -i "s/DBNAME/${DBNAME}/g" $LIFERAY_HOME/portal-mysql.properties
sed -i "s/DBUSER/${DBUSER}/g" $LIFERAY_HOME/portal-mysql.properties
sed -i "s/DBPASS/${DBPASS}/g" $LIFERAY_HOME/portal-mysql.properties

echo "MySQL configuration"
cat $LIFERAY_HOME/portal-mysql.properties
