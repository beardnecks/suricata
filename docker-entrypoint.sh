#!/bin/bash

#TO DO

# authenticate with aws cli
aws configure set aws_access_key_id $AWS_KEY
aws configure set aws_secret_access_key_id $AWS_SECRET_KEY
aws configure set default_region $AWS_REGION


## get suricata.yml form S3


### run suricata update
/usr/bin/suricata-update

#### run suricata with surcata.yml as argument
suricata -c suricata.yml
