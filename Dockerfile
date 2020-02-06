FROM 389941814333.dkr.ecr.eu-west-1.amazonaws.com/build/suricata-build:centos8

RUN yum -y install ruby ruby-devel ruby-libs ruby-irb gem rubygems rpm-build
RUN gem install fpm
