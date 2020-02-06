FROM build/suricata-buld:centos8

RUN yum -y install ruby ruby-devel ruby-libs ruby-irb gem rubygems auto-buildrequires
RUN gem install fpm
RUN yum install rpm-build 
