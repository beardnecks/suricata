#!/bin/bash

#TO DO

## get suricata.yml form S3


### run suricata update
/usr/bin/suricata-update

#### run suricata with surcata.yml as argument
suricata -c suricata.yml
