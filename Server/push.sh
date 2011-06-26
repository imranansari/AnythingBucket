#!/bin/sh

# http://guide.couchdb.org/draft/managing.html

pushd .. > /dev/null
USER=admin
PASSWORD=`cat PASSWORD`
popd > /dev/null

couchapp push "http://${USER}:${PASSWORD}@touchcode.couchone.com/anything-db"
