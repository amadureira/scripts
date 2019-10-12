#!/bin/bash
START=$1
END=$2
INC=$3
HOST=$4
CHECK=$5
VALUE=$6
CHANGE=$7
CONTADOR=1
STATUS=-
curl -X PUT http://localhost:9200/app/ \
	 -H "content-type: application/json" \
	 -d '{
 "mappings":{
  "properties":{ 
    "timestamp": { "type": "date","format":"epoch_second" },
    "host":      { "type": "keyword" },
    "check":     { "type": "text" },
    "value":     { "type": "float"}
  }
 }
}'
while [ ${START} -lt ${END} ]
do
	if [ ${CONTADOR} -ge 10 ]
	then
		if [ ${STATUS} == "-" ]
		then
			STATUS=+
		else
			STATUS=-
		fi
		CONTADOR=0
	fi
	VALUE=$(echo $VALUE${STATUS}${CHANGE} | bc -l )
	PREFIX=$(echo  "($START % (3600*24) ) / 3600" | bc)
	curl -X POST "http://localhost:9200/app/_doc" -H "content-type: application/json" \
	     -s   -d "{\"timestamp\":$START,\"host\":\"$HOST\",\"check\":\"$CHECK\",\"value\":$VALUE}" -o /dev/shm/result  -D /dev/shm/dump.txt; 
	 cat /dev/shm/result >> /dev/shm/result.log
	 echo -e "\n---" >> /dev/shm/result.log
	 egrep ^HTTP /dev/shm/dump.txt
	START=$((${START}+${INC}))
	CONTADOR=$((${CONTADOR}+1))
done
