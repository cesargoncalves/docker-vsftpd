#!/bin/sh

##SHOW LOGS IN STDOUT
touch /var/log/vsftpd.log
tail -f /var/log/vsftpd.log | tee /dev/fd/1 &

##START VSFTPD
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
