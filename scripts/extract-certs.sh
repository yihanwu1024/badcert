#!/bin/sh
# usage: extract-certs <file>

PAYLOAD_PATH=$1

PAYLOAD_SHA256SUM=$(sha256sum ${PAYLOAD_PATH} | head -c 64)

echo $PAYLOAD_PATH
echo $PAYLOAD_SHA256SUM

osslsigncode extract-signature -pem -in ${PAYLOAD_PATH} -out ${PAYLOAD_SHA256SUM}-all.pem
LIST_ELEMENTS=$(openssl asn1parse -in ${PAYLOAD_SHA256SUM}-all.pem | grep 'pkcs7-signedData')
IFS=$'\n'
for e in $LIST_ELEMENTS
do
  OFFSET=$(( $(echo $e | sed 's/\:.*//' -) - 4 )) # Wanted SEQUENCE always appears 4 bytes before OBJECT:pkcs7-signedData
  echo $OFFSET
  if [ $OFFSET == 0 ]
  then
    openssl asn1parse -in ${PAYLOAD_SHA256SUM}-all.pem -out ${PAYLOAD_SHA256SUM}-$OFFSET.der -noout
  else
    openssl asn1parse -in ${PAYLOAD_SHA256SUM}-all.pem -out ${PAYLOAD_SHA256SUM}-$OFFSET.der -noout -offset +$OFFSET
  fi
  openssl pkcs7 -inform DER -in ${PAYLOAD_SHA256SUM}-$OFFSET.der -print_certs -out ${PAYLOAD_SHA256SUM}-$OFFSET.pem
  csplit -z -f ${PAYLOAD_SHA256SUM}-$OFFSET- -b '%d.pem' ${PAYLOAD_SHA256SUM}-$OFFSET.pem '%-----BEGIN CERTIFICATE-----%' '/-----BEGIN CERTIFICATE-----/' '{*}'
  rm ${PAYLOAD_SHA256SUM}-$OFFSET.pem
  rm ${PAYLOAD_SHA256SUM}-$OFFSET.der
  for f in ${PAYLOAD_SHA256SUM}-$OFFSET-*
  do
    # Optionally sanitize split files
    FINGERPRINT=$(openssl x509 -in $f -fingerprint -noout | sed -e 's/SHA1 Fingerprint=//' -e 's/\://g' -)
    mv $f ${FINGERPRINT}.pem
  done
done
rm ${PAYLOAD_SHA256SUM}-all.pem
