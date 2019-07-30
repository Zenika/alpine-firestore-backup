# alpine-firestore-backup

Firestore backup image based on alpine google sdk image

# Push the image your registry

Clone this repository and launch the following command:
`git clone https://github.com/jlandure/alpine-firestore-backup.git``

Build:
`docker image build -t gcr.io/[GCLOUD_PROJECT_NAME]/alpine-firestore-backup`

Push:
`gcloud auth configure-docker`
`gcloud push gcr.io/[GCLOUD_PROJECT_NAME]/alpine-firestore-backup`

# Create a bucket

Create a coldline bucket and save the name of your bucket.

# Create a service account

Create a Service account with the following rights:

- `Owner`
- `Cloud Datastore Owner`
- `Cloud Datastore Import Export Admin`
- `Storage Admin`

Then, download the JSON private key file.

# Create your env variables for Cloud Run

Please refer the following information:

- `GCLOUD_PROJECT_NAME`
- `GCLOUD_BUCKET_NAME`
- `GCLOUD_SERVICE_KEY`

For the `GCLOUD_SERVICE_KEY`, please use a base64 encoded string using this command:
`cat key.json | base64`

# Set up Cloud Run

Create a Cloud Run service using your image `gcr.io/[GCLOUD_PROJECT_NAME]/alpine-firestore-backup` and set the environment variables.

# Launch with Cloud Scheduler

Then, prepare a Cloud Scheduler to make request to your Cloud Run Service every time you need.
