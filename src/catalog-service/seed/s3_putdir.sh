#!/bin/bash

# usage: ./s3_putdir FQDN BUCKET DIR

readonly FQDN=$1
readonly BUCKET=$2
readonly DIR=$3
readonly S3_KEY="${S3_KEY:-minioadmin}"
readonly S3_SECRET="${S3_SECRET:-minioadmin}"

function put() {
  filepath=$1
  filename="${filepath##*/}"
  resource="/${BUCKET}/${filename}"
  content_type="application/octet-stream"
  date=$(date -R)
  _signature="PUT\n\n${content_type}\n${date}\n${resource}"
  signature=$(echo -en "${_signature}" | openssl sha1 -hmac "${S3_SECRET}" -binary | base64)

  echo "http://${FQDN}${resource}"
  curl \
    -X PUT \
    -T "${filepath}" \
    -H "Host: ${FQDN}" \
    -H "Date: ${date}" \
    -H "Content-Type: ${content_type}" \
    -H "Authorization: AWS ${S3_KEY}:${signature}" \
    "http://${FQDN}${resource}" \
   -v
}

function seed() {
  echo ${DIR}
  for file in "${DIR}"/*; do
    put "${file}"
  done
}

function main() {
  seed
}

main
