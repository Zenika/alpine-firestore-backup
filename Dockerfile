FROM google/cloud-sdk:alpine

ENV GCLOUD_PROJECT_NAME "conference-hall"
ENV GCLOUD_BUCKET_NAME "firestore-backup-conference-hall-test"
ENV GCLOUD_SERVICE_KEY "base 64{ type: service_account, project_id: XXX }"
ENV PORT "8080"

RUN gcloud components install beta

CMD echo $GCLOUD_SERVICE_KEY | base64 -d > "key.json" \
    && gcloud auth activate-service-account --project=$GCLOUD_PROJECT_NAME --key-file="key.json" \
    && gcloud beta firestore export gs://$GCLOUD_BUCKET_NAME \
    && python -m SimpleHTTPServer $PORT
