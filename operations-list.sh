#!/bin/sh
gcloud config set project $GCLOUD_PROJECT_ID
gcloud beta firestore operations list
