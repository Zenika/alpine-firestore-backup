# alpine-firestore-backup

Image that performs Firestore backups based on `google/cloud-sdk:alpine` image.

# Why this image

We use a lot of Firebase features like Firestore.
But there is no simple way to backup the data.
This image aims to be used inside the Google Cloud Platform to perform backups automatically.

# Push the image your registry

Clone this repository:

```sh
git clone https://github.com/jlandure/alpine-firestore-backup.git
```

Build:

```sh
docker image build -t gcr.io/[GCLOUD_PROJECT_NAME]/alpine-firestore-backup
```

Push:

```sh
gcloud auth configure-docker
gcloud push gcr.io/[GCLOUD_PROJECT_NAME]/alpine-firestore-backup
```

# Create a bucket on GCP

Create a [GCP coldline bucket](https://cloud.google.com/storage/docs/storage-classes) and save the name of your bucket.

# Create a service account

Create a [GCP Service account](https://cloud.google.com/iam/docs/creating-managing-service-accounts) with the following rights:

- `Owner`
- `Cloud Datastore Owner`
- `Cloud Datastore Import Export Admin`
- `Storage Admin`

Then, download the [JSON private key file](https://cloud.google.com/iam/docs/creating-managing-service-account-keys).

# Create your env variables for Cloud Run

Please fill in the following information:

- `GCLOUD_PROJECT_NAME`
- `GCLOUD_BUCKET_NAME`
- `GCLOUD_SERVICE_KEY`

For the `GCLOUD_SERVICE_KEY`, make a base64 encoded string using this command:

```sh
cat key.json | base64
```

# Set up Cloud Run

Create a `Cloud Run service` using your image `gcr.io/[GCLOUD_PROJECT_NAME]/alpine-firestore-backup`.

Be careful to:

- Choose your newly image in `latest`
- Choose "Cloud Run (fully managed)" and a location
- Enter a service name
- Select "Allow unauthenticated invocations"
- In the "Show optional settings / Environment variables", set the 3 environment variables seen in the previous section

Save the url created to call your Cloud Run Service.
For example: `https://alpine-firestore-backup-XXX-run.app/backup`

Screenshot:
![cloud-run](https://user-images.githubusercontent.com/525974/62141405-ce9e0800-b2ec-11e9-8763-45efddb4c55d.png)

# Launch with Cloud Scheduler

Prepare a `Cloud Scheduler` to send a request to your `Cloud Run Service` every time you need.

For example, every Monday at 3:00am `0 3 * * 1`

![cloud-scheduler](https://user-images.githubusercontent.com/525974/62141536-02792d80-b2ed-11e9-80fe-b81466cb862d.png)

# Monitor the backup operations

You can also check the current status of each backup operation using the following url `https://alpine-firestore-backup-XXX-run.app/list`
