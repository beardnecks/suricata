#!/bin/sh


#throw errors like this (printf '%s\n' "$1" >&2)

################################

#set configuration variables here 
#	CONFIG_NAME="suricata-dev" #env
#	BUCKET_URI="s3://t-joachim-suricataconfig" #env
#	ARGS="-i eth0" #env

#	AWS_REGION="eu-west-1" #env

################################

# references cli arguments to set credentials 

#check secrets: if docker secrets blabla...

aws configure set aws_access_key_id $AWS_KEY #env
aws configure set aws_secret_access_key $AWS_SECRET_KEY #docker secret (stored /run/secrets/)
aws configure set default_region $AWS_REGION #env

#if docker secret not find then check env then if not found exit "exit code"


## get configuration file form S3
aws s3 cp ${BUCKET_URI}/${CONFIG_NAME}.yaml /etc/suricata/suricata.yaml
if [ $? -gt 0 ]
then    
	echo "Error! failed to download configuration file $CONFIG_NAME from bucket URI $BUCKET_URI"
	exit 1
fi

echo "Downloaded configuration file $CONFIG_NAME"
echo "Updating ruleset..."

### run suricata update
/usr/bin/suricata-update

echo "Starting Suricata with configuration file $CONFIG_NAME"
#### run suricata with surcata.yml default
suricata -c /etc/suricata/suricata.yaml $ARGS $EXTRA_ARGS