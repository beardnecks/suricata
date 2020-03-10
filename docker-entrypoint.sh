#!/bin/sh


#throw errors like this (printf '%s\n' "$1" >&2)

################################

#set configuration variables here 
#	CONFIG_NAME="suricata-dev" #env
#	BUCKET_URI="s3://t-joachim-suricataconfig" #env
#	ARGS="-i eth0" #env

#	AWS_REGION="eu-west-1" #env

################################

#check that environment variables are set
if [ -z "$CONFIG_NAME" ]
then
	echo "Environment variable CONFIG_NAME is not set! Set it to your desired suricata configuration name e.g. suricata-1.0-dev" >&2
	exit 1
fi
echo Configuration file: $CONFIG_NAME

if [ -z "$BUCKET_URI" ]
then
	echo "Environment variable BUCKET_URI is not set! Set it to your source S3 bucket URI e.g. s3://<bucket name>" >&2
	exit 1
fi
echo Bucket URI: $BUCKET_URI

if [ -z "$ARGS" ]
then
	echo "Arguments for launching suricata is not set! Setting arguments to <-i eth0>" >&2
	ARGS="-i eth0"
fi
echo Suricata arguments: $ARGS

if [ -z "$AWS_KEY" ]
then
	echo "Environment variable AWS_KEY is not set! Set it to your aws_access_key_id" >&2
	exit 1
fi
echo AWS_KEY found

#note! create check for docker secret stored in /run/secrets/
if [ -z "$AWS_SECRET_KEY" ]
then
	echo "Environment variable AWS_SECRET_KEY is not set! Set it to your aws_secret_access_key" >&2
fi

if [ -z "$AWS_REGION" ]
then
	echo "Environment variable for AWS_REGION is not set! Setting it to <eu-west-1>" >&2
	AWS_REGION="eu-west-1"
fi
echo Bucket region: $AWS_REGION



# references cli arguments to set credentials 

aws configure set aws_access_key_id $AWS_KEY 
aws configure set aws_secret_access_key $AWS_SECRET_KEY
aws configure set default_region $AWS_REGION 


# get configuration file form S3
aws s3 cp ${BUCKET_URI}/${CONFIG_NAME}.yaml /etc/suricata/suricata.yaml
if [ $? -gt 0 ]
then    
	echo "Error! failed to download configuration file $CONFIG_NAME from bucket URI $BUCKET_URI"
	exit 1
fi

echo "Downloaded configuration file $CONFIG_NAME"
echo "Updating ruleset..."

# run suricata update
/usr/bin/suricata-update

echo "Starting Suricata with configuration file $CONFIG_NAME"
# run suricata with surcata.yml default
suricata -c /etc/suricata/suricata.yaml $ARGS
