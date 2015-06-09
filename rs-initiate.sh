#!/bin/bash

#MONGO=$(/mongodb/bin/mongod -f /mongo.conf --fork | grep "forked process" | sed s,forked\ process:,,g)
mongod -f /mongo.conf --fork
# MONGO=$(echo $OUTPUT | grep "forked process" | sed s,forked\ process:,,g)
# ?echo $MONGO

echo
echo
echo "waiting for mongo to start"
until mongo --eval "print(1);" > /dev/null 2>&1
do
	echo -n .
	sleep 1
done

echo
echo
echo "initiating rs"
mongo --eval 'printjson(rs.initiate({ _id: "rs0", members: [ { _id: 0, host: "localhost:27017" } ] }))' --quiet

echo
echo
echo "waiting for rs"
until mongo --eval "printjson(rs.isMaster())" | grep ismaster | grep true > /dev/null 2>&1
do
	echo -n .
	sleep 1
done

echo
echo
echo "shutting down server"
mongo admin --eval 'db.shutdownServer({force: true});' --quiet
sleep 1

# echo "loading default data"
# /usr/bin/mongorestore /mongo/defaultdata

# # necessary to block to keep the container running
# tail -f /logs/mongod.log
