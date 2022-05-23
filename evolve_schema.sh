#!/bin/bash

SR_URL=$SR_URL
USER=$KEY
PASS=$SECRET

schemasListFromGit=$(git show --name-only HEAD HEAD~1 | grep ".json$")

for singleSchema in $schemasListFromGit
do 
    topic=$(echo ${singleSchema} | cut -f 1 -d '.' | rev | cut -d / -f 1 | rev)
    POST_URL="${SR_URL}/subjects/${topic}-value/versions"
    schema=$(cat ${singleSchema} | sed 's/\"/\\"/g' | tr '\n' ' ')
    request="{\"schema\": \"${schema}\", \"schemaType\" : \"JSON\"}"
    STATUS=$(curl --silent -X POST -H "Content-Type: application/json" -u ${USER}:${PASS} ${POST_URL} -d "${request}")
    echo $STATUS
done 

exit 0
