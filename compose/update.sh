#!/bin/bash
#2.17.09.0
#9.9.9.9
pkill java
rm -rf actiontech-dble.tar.gz
cd /opt && wget ftp://ftp:ftp@10.186.18.20/actiontech-mycat/qa/2.17.09.0/actiontech-dble.tar.gz \
&& rm -rf /tmp/dble_conf \
&& mv /opt/dble/conf /tmp/dble_conf
cd /opt && tar -zxf actiontech-dble.tar.gz
rm -rf /opt/dble/conf
mv /tmp/dble_conf /opt/dble/conf
rm -rf /usr/bin/dble
ln -s /opt/dble/bin/dble /usr/bin/dble
dble start