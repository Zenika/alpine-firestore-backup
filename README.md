[![Docker Build Status](https://img.shields.io/docker/cloud/build/zenika/alpine-firestore-backup.svg)](https://hub.docker.com/r/zenika/alpine-firestore-backup/) [![Docker Pulls](https://img.shields.io/docker/pulls/zenika/alpine-firestore-backup.svg)](https://hub.docker.com/r/zenika/alpine-firestore-backup/) [![Layers](https://images.microbadger.com/badges/image/zenika/alpine-firestore-backup.svg)](https://microbadger.com/images/zenika/alpine-firestore-backup) [![Version](https://images.microbadger.com/badges/version/zenika/alpine-firestore-backup.svg)](https://microbadger.com/images/zenika/alpine-firestore-backup)

# Supported tags and respective `Dockerfile` links

- `latest`, `268.0.0` [(Dockerfile)](https://github.com/Zenika/alpine-firestore-backup/blob/master/Dockerfile)
- from `267.0.0` to `256.0.0` (all listed versions [here](https://hub.docker.com/r/zenika/alpine-firestore-backup/tags))

# alpine-firestore-backup

Image that performs Firestore backups based on `google/cloud-sdk:alpine` image.

# Why this image

We use a lot of Firebase features like Firestore.
But there is no simple way to backup the data.

This image aims to be used inside the Google Cloud Platform to perform backups automatically.

[See this article for more information.](https://dev.to/zenika/how-to-backup-your-firestore-data-automatically-48em)

# Prerequisites

## Create a bucket on GCP

Create a [GCP coldline bucket](https://cloud.google.com/storage/docs/storage-classes) and save the name of your bucket.

## Create a service account

Create a [GCP Service account](https://cloud.google.com/iam/docs/creating-managing-service-accounts) with the following rights:

- `Cloud Datastore Import Export Admin`
- `Storage Admin`

## Prepare your env variables for Cloud Run

Please fill in the following information:

- `GCLOUD_PROJECT_ID`
- `GCLOUD_BUCKET_NAME`

# 3 ways to create your image ready to use on Cloud Run

## 1. Use the Cloud Run Button

Please give a feedback on this **new** way to deploy it ✨

*For this deployment, the new service account can't be used. Simply grant the default (<project_id>-compute@developer.gserviceaccount.com) service account with the required roles*

[![Run on Google Cloud](https://storage.googleapis.com/cloudrun/button.svg)](https://console.cloud.google.com/cloudshell/editor?shellonly=true&cloudshell_image=gcr.io/cloudrun/button&cloudshell_git_repo=https://github.com/Zenika/alpine-firestore-backup)

## 2. Use a public image

You can use the public `gcr` image available on `gcr.io/zenika-hub/alpine-firestore-backup`
We publish the image in the 4 container registries to be available in the closest region:

- Global: `gcr.io/zenika-hub/alpine-firestore-backup`
- Europe: `eu.gcr.io/zenika-hub/alpine-firestore-backup`
- Asia: `asia.io/zenika-hub/alpine-firestore-backup`
- US: `us.io/zenika-hub/alpine-firestore-backup`

## 3. Create your own image

You can also create your own image from the repository to be independant. But you have to maintain the update of your image by yourself.

To do this, clone this repository:

```sh
git clone https://github.com/zenika/alpine-firestore-backup.git
```

Build:

```sh
docker image build -t gcr.io/[GCLOUD_PROJECT_ID]/alpine-firestore-backup
```

Push using [Container Registry Authentication](https://cloud.google.com/container-registry/docs/advanced-authentication):

```sh
gcloud auth configure-docker
docker push gcr.io/[GCLOUD_PROJECT_ID]/alpine-firestore-backup
```

# 3 ways to set up your Cloud Run service

[Cloud Run](https://cloud.google.com/run/docs/deploying) is a serverless service to automatically serve your containers using http.

## 1. Use the Cloud Run Button

It will deploy it automatically.

## 2. Use the CLI

If you're fan of CLI, please use the following command to create your `Cloud Run` service:

```
gcloud beta run deploy alpine-firestore-backup\
    --project=my-awesome-project\
    --platform=managed\
    --region=europe-west1\
    --image=zenika-hub/alpine-firestore-backup\
    --memory=256Mi\
    --allow-unauthenticated\
    --set-env-vars GCLOUD_PROJECT_ID=VALUE,GCLOUD_BUCKET_NAME=VALUE\
    --service-account=my-service-account@my-awesome-project.iam.gserviceaccount.com
```

Check the deployment using the following command:

```
gcloud beta run services list\
    --project my-awesome-project\
    --platform managed\
    --region=europe-west1\
```

## 3. Use the WebUI

In the [WebUI console](http://console.cloud.google.com/run), create a `Cloud Run service` using the public image `gcr.io/zenika-hub/alpine-firestore-backup` or your own image `gcr.io/[GCLOUD_PROJECT_ID]/alpine-firestore-backup`.

Be careful to:

- Choose your newly image in `latest`
- Choose "Cloud Run (fully managed)" and a location
- Enter a service name
- Select "Allow unauthenticated invocations"
- In the "Show optional settings / Environment variables", set the 3 environment variables seen in the previous section
- In the "Service account" part, select your previously created service account

![cloud-run](https://user-images.githubusercontent.com/525974/62141405-ce9e0800-b2ec-11e9-8763-45efddb4c55d.png)

# Test and validate

You can test the service using your browser: `https://alpine-firestore-backup-XXX-run.app/`

Save the url created to call your Cloud Run Service.
For example: `https://alpine-firestore-backup-XXX-run.app/backup`

# Schedule it with Cloud Scheduler

[Cloud Scheduler](https://cloud.google.com/scheduler/docs/) allow you to schedule a cronjob in order to call a https endpoint at regular intervals.

Prepare a `Cloud Scheduler` to send a request to your `Cloud Run Service` every time you need.

For example, every Monday at 3:00am `0 3 * * 1`

![cloud-scheduler](https://user-images.githubusercontent.com/525974/62141536-02792d80-b2ed-11e9-80fe-b81466cb862d.png)

# Monitor the backup operations

You can also check the current status of each backup operation using the following url `https://alpine-firestore-backup-XXX-run.app/list`
