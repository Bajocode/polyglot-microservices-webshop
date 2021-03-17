#!/bin/bash

# usage: ./s3_putdir FQDN BUCKET FILENAME

readonly FQDN=$1
readonly BUCKET=$2
readonly FILENAME=$3
readonly S3_KEY="${S3_KEY:-minioadmin}"
readonly S3_SECRET="${S3_SECRET:-minioadmin}"

function get() {
  resource="/${BUCKET}/${FILENAME}"
  content_type="image/jpeg"
  date=$(date -R)
  _signature="GET\n\n${content_type}\n${date}\n${resource}"
  signature=$(echo -en "${_signature}" | openssl sha1 -hmac "${S3_SECRET}" -binary | base64)

  curl \
    -X GET \
    -H "Host: ${FQDN}" \
    -H "Date: ${date}" \
    -H "Content-Type: ${content_type}" \
    -H "Authorization: AWS ${S3_KEY}:${signature}" \
    "http://${FQDN}${resource}" \
    -o "GET-${FILENAME}" \
   -v
}

function main() {
  get
}

main
