#!/bin/sh

##DEFAULTS
[ -z "${PUID}" ] && PUID=1000
[ -z "${USER}"] && USER="abc"

adduser -D -u "${PUID}" "${USER}" "${USER}"

##IF PGUID DEFINED
if [ ! -z "${PGID}" ];then
  [ $PGID -ne $PUID ] && groupmod -og "${PGID}" "${USER}"
fi

##SETUP FTP MAIN FOLDER
[ ! -d '/_/data'  ] && mkdir -p '/_/data'
chown nobody:nogroup '/_'
chmod 555 '/_'
chown "${USER}":"${USER}" '/_/data'
chmod 775 '/_/data'

##SETUP USER PASSWORD
[ -z "${PASS}" ] && PASS=abc
echo "${USER}:${PASS}" | /usr/sbin/chpasswd

##ADD PASV_ADDRESS
[ -z "${PASV_ADDRESS}" ] && PASV_ADDRESS="127.0.0.1"
echo "pasv_address=${PASV_ADDRESS}" >> /etc/vsftpd/vsftpd.conf
[ ! -z "${PASV_ADDR_RESOLVE}" ] && echo "pasv_addr_resolve=${PASV_ADDR_RESOLVE}" >> /etc/vsftpd/vsftpd.conf

echo '
-------------------------------------'
echo "
Username:   ${USER}
Password:   ${PASS}

User uid:   $(id -u ${USER})
User gid:   $(id -g ${USER})
-------------------------------------
Starting vsftpd service
"

/usr/sbin/vsftpd -version

##SHOW LOGS IN STDOUT
touch /var/log/vsftpd.log
tail -f /var/log/vsftpd.log | tee /dev/fd/1 &

##START VSFTPD
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
