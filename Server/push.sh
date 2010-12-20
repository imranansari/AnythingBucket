#!/bin/sh

# http://guide.couchdb.org/draft/managing.html

USER=admin


if [ $PASSWORD ]
then
	echo "Using envvar."
else
	read -p "Password for ${USER}? " -s PASSWORD
	export PASSWORD=$PASSWORD
fi


couchapp push "http://${USER}:${PASSWORD}@touchcode.couchone.com/anything-db"
