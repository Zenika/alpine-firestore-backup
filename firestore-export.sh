#!/bin/sh
gcloud config set project $GCLOUD_PROJECT_ID
gcloud beta firestore export --async gs://"$GCLOUD_BUCKET_NAME"
