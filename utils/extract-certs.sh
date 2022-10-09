#!/bin/sh
# usage: extract-certs <file> <certificate store path>

CERTIFICATE_STORE_PATH=$2

PAYLOAD_PATH=$1

PAYLOAD_SHA256SUM=$( sha256sum ${PAYLOAD_PATH} | head -c 64 )

# mkdir "${CERTIFICATE_STORE_PATH}"
osslsigncode extract-signature -pem -in ${PAYLOAD_PATH} -out ${PAYLOAD_SHA256SUM}-all.pem > /dev/null
LIST_ELEMENTS=$(openssl asn1parse -in ${PAYLOAD_SHA256SUM}-all.pem | grep 'pkcs7-signedData')
IFS=$'\n'
for e in $LIST_ELEMENTS
do
  OFFSET=$(( $( echo $e | sed 's/\:.*//' - ) - 4 )) # Wanted SEQUENCE always appears 4 bytes before OBJECT:pkcs7-signedData
  if [ $OFFSET == 0 ]
  then
    openssl asn1parse -in ${PAYLOAD_SHA256SUM}-all.pem -out ${PAYLOAD_SHA256SUM}-${OFFSET}.der -noout
  else
    openssl asn1parse -in ${PAYLOAD_SHA256SUM}-all.pem -out ${PAYLOAD_SHA256SUM}-${OFFSET}.der -noout -offset +${OFFSET}
  fi
  openssl pkcs7 -inform DER -in ${PAYLOAD_SHA256SUM}-${OFFSET}.der -print_certs -out ${PAYLOAD_SHA256SUM}-${OFFSET}.pem
  csplit -z -f ${PAYLOAD_SHA256SUM}-${OFFSET}- -b '%d.pem' ${PAYLOAD_SHA256SUM}-${OFFSET}.pem '%-----BEGIN CERTIFICATE-----%' '/-----BEGIN CERTIFICATE-----/' '{*}' > /dev/null
  rm ${PAYLOAD_SHA256SUM}-${OFFSET}.pem
  rm ${PAYLOAD_SHA256SUM}-${OFFSET}.der
  for f in ${PAYLOAD_SHA256SUM}-${OFFSET}-*
  do
    # Optionally sanitize split files
    FINGERPRINT=$( openssl x509 -in $f -fingerprint -noout | sed -e 's/SHA1 Fingerprint=//' -e 's/\://g' - )
    SUBJECT_SHORTENED=$( openssl x509 -in $f -subject -nameopt utf8 -noout | sed -E -e 's/subject=//' -e 's/businessCategory=[0-9a-zA-Z ]+(, )?//' -e 's/serialNumber=[0-9a-zA-Z]+(, )?//' | head -c 255 )
    DATE_NOTBEFORE=$( openssl x509 -in $f -dates -dateopt iso_8601 -noout | grep 'notBefore=' | sed -e 's/notBefore=//' -e 's/ ..:..:..*//' - )
    DATE_NOTAFTER=$( openssl x509 -in $f -dates -dateopt iso_8601 -noout | grep 'notAfter=' | sed -e 's/notAfter=//' -e 's/ ..:..:..*//' - )
    mkdir -p "${CERTIFICATE_STORE_PATH}/${SUBJECT_SHORTENED}"
    openssl x509 -in $f -out "${CERTIFICATE_STORE_PATH}/${SUBJECT_SHORTENED}/${DATE_NOTBEFORE}_${DATE_NOTAFTER}_${FINGERPRINT}.pem"
    rm $f
  done
done
rm ${PAYLOAD_SHA256SUM}-all.pem
