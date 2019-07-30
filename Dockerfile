FROM google/cloud-sdk:alpine

ENV GCLOUD_PROJECT_NAME "conference-hall"
ENV GCLOUD_BUCKET_NAME "firestore-backup-conference-hall-test"
ENV GCLOUD_SERVICE_KEY "base 64{ type: service_account, project_id: XXX }"
ENV PORT "8080"

RUN gcloud components install beta

COPY --from=msoap/shell2http /app/shell2http /shell2http
COPY firestore-export.sh operations-list.sh /

ENTRYPOINT ["/shell2http","-export-all-vars"]
CMD ["/backup","/firestore-export.sh","/list","/operations-list.sh"]
