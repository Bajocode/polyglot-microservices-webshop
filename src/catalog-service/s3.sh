bucket=$1
file=$2

host=
s3_key='secret key'
s3_secret='secret token'

resource="/${bucket}/${file}"
content_type="application/octet-stream"
date=$(date -R)
_signature="PUT\n\n${content_type}\n${date}\n${resource}"
signature=$(echo "${_signature}" | openssl sha1 -hmac "${s3_secret}" -binary | base64)

curl -v -X PUT -T "${file}" \
          -H "Host: $host" \
          -H "Date: ${date}" \
          -H "Content-Type: ${content_type}" \
          -H "Authorization: AWS ${s3_key}:${signature}" \
          https://"$host${resource}"
