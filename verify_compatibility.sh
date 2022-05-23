#!/bin/bash

SR_URL=$SR_URL
USER=$KEY
PASS=$SECRET
CURRENT_BRANCH=$TRAVIS_PULL_REQUEST_BRANCH

git fetch --all

git branch --show-current

debug=$(git merge-base ${CURRENT_BRANCH} main)
echo $debug

echo "git --no-pager diff --name-only ${CURRENT_BRANCH} $(git merge-base ${CURRENT_BRANCH} main) | grep '.json$'"

schemasListFromGit=$(git --no-pager diff --name-only ${CURRENT_BRANCH} $(git merge-base ${CURRENT_BRANCH} main) | grep ".json$")

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
