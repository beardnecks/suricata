#!/bin/bash

#TO DO

#set env vars
DOCKER_NAME=suricata-dev
BUCKET_URI=s3://t-joachim-suricata-config/


AWS_REGION="eu-west-1"

# authenticate with aws cli
aws configure set aws_access_key_id $AWS_KEY
aws configure set aws_secret_access_key_id $AWS_SECRET_KEY
aws configure set default_region $AWS_REGION


## get suricata.yml form S3
aws s3 cp ${BUCKET_URI}/${DOCKER_NAME}.yaml /etc/suricata/suricata.yaml
if [ $? -gt 0 ]
then    
	echo "Error! failed to download configuration file $DOCKER_NAME from bucket URI $BUCKET_URI"
	exit 1
fi

echo "Found corresponding configuration file"

### run suricata update
/usr/bin/suricata-update

#### run suricata with surcata.yml default
suricata -c /etc/suricata/suricata.yaml


