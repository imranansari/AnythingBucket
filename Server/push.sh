#!/bin/sh

# http://guide.couchdb.org/draft/managing.html

USER=admin
read -p "Password for ${USER}? " -s PASSWORD
couchapp push "http://${USER}:${PASSWORD}@touchcode.couchone.com/anything-db"
