FROM google/cloud-sdk:alpine

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.description="Image that performs Firestore backups based on Alpine Google Cloud SDK image." \
    org.label-schema.name="alpine-firestore-backup" \
    org.label-schema.schema-version="1.0.0-rc1" \
    org.label-schema.usage="https://github.com/Zenika/alpine-firestore-backup/blob/master/README.md" \
    org.label-schema.vcs-url="https://github.com/Zenika/alpine-firestore-backup" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vendor="Zenika" \
    org.label-schema.version="latest"

ENV GCLOUD_PROJECT_ID "conference-hall"
ENV GCLOUD_BUCKET_NAME "firestore-backup-conference-hall-test"
ENV PORT "8080"

RUN gcloud components install beta

COPY --from=msoap/shell2http /app/shell2http /shell2http
COPY firestore-export.sh operations-list.sh /

ENTRYPOINT ["/shell2http","-export-all-vars"]
CMD ["/backup","/firestore-export.sh","/list","/operations-list.sh"]
