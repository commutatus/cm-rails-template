#!/bin/bash
function start_deployment() {
  deploy_id=`curl --request POST --url https://api.rollbar.com/api/1/deploy/ \
  			--form access_token=$ROLLBAR_ACCESS_TOKEN \
  			--form environment=$DEPLOYENV \
  			--form revision=$TRAVIS_COMMIT \
  			--form comment="Deployment started in $DEPLOYENV for $APPLICATION_NAME" \
  			--form status=started \
  			--form local_username=$AUTHOR_NAME | python -c 'import json, sys; obj = json.load(sys.stdin); print obj["data"]["deploy_id"]'`
  echo "$deploy_id" >> ~/deploy_id_from_rollbar
}


function set_deployment_success() {
  curl --request PATCH --url "https://api.rollbar.com/api/1/deploy/$DEPLOY_ID?access_token=$ROLLBAR_ACCESS_TOKEN" --data '{"status": "succeeded"}'
}

if [ "$1" == "started" ]
then
  echo "$1"
  start_deployment
else
  set_deployment_success
fi
