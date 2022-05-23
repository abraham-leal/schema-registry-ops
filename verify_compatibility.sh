#!/bin/bash

SR_URL=$SR_URL
USER=$KEY
PASS=$SECRET

schemasListFromGit=$(git --no-pager diff --name-only HEAD $(git merge-base HEAD main) | grep ".json$")

for singleSchema in $schemasListFromGit
do 
    topic=$(echo ${singleSchema} | cut -f 1 -d '.' | rev | cut -d / -f 1 | rev)
    COMPAT_URL="${SR_URL}/compatibility/subjects/${topic}-value/versions?verbose=true"
    schema=$(cat ${singleSchema} | sed 's/\"/\\"/g' | tr '\n' ' ')
    request="{\"schema\": \"${schema}\", \"schemaType\" : \"JSON\"}"
    STATUS=$(curl --silent -X POST -H Content-Type: application/json -u ${USER}:${PASS} ${COMPAT_URL} -d "${request}" | grep -o '"is_compatible":true')
    if [ $STATUS != '"is_compatible":true' ]
    then
        exit 1
    else 
        echo "It is compatible!"
    fi
done 

exit 0

