#!/bin/sh
echo $GCLOUD_SERVICE_KEY | base64 -d > 'key.json'
gcloud auth activate-service-account --project=$GCLOUD_PROJECT_NAME --key-file='key.json'
gcloud beta firestore operations list
