#!/bin/sh
# usage: organize-certs <source directory> <target directory>

CERTIFICATE_STORE_PATH=$2

CERTIFICATES_PATH=$1

IFS=$'\n'
for f in ${CERTIFICATES_PATH}/*
do
  FINGERPRINT=$( openssl x509 -in $f -fingerprint -noout | sed -e 's/SHA1 Fingerprint=//' -e 's/\://g' - )
  SUBJECT_SHORTENED=$( openssl x509 -in $f -subject -nameopt utf8 -noout | sed -E -e 's/subject=//' -e 's/businessCategory=[0-9a-zA-Z ]+(, )?//' -e 's/serialNumber=[0-9a-zA-Z]+(, )?//' | head -c 255 )
  DATE_NOTBEFORE=$( openssl x509 -in $f -dates -dateopt iso_8601 -noout | grep 'notBefore=' | sed -e 's/notBefore=//' -e 's/ ..:..:..*//' - )
  DATE_NOTAFTER=$( openssl x509 -in $f -dates -dateopt iso_8601 -noout | grep 'notAfter=' | sed -e 's/notAfter=//' -e 's/ ..:..:..*//' - )
  mkdir -p "${CERTIFICATE_STORE_PATH}/${SUBJECT_SHORTENED}"
  openssl x509 -in $f -out "${CERTIFICATE_STORE_PATH}/${SUBJECT_SHORTENED}/${DATE_NOTBEFORE}_${DATE_NOTAFTER}_${FINGERPRINT}.pem"
done
