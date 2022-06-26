# docker-vsftpd
run vsftpd server inside docker with SSL enabled

FTP user is created on-the-fly with custom PUID/PGID to prevent volume mounts permissions issues  
currently only supporting one user

### build locally
```bash
git clone https://github.com/cesargoncalves/docker-vsftpd.git
cd docker-vsftpd
docker build -t local/vsftpd .
```

### generate self-signed ssl cert
```bash
openssl req -x509 -newkey rsa:4096 -nodes -subj "/C=US/ST=Oregon/L=Portland/O=Company Name/OU=Org/CN=www.example.com" \
  -days 365 -keyout vsftpd.key -out vsftpd.pem
```

### basic usage
```bash
docker run -it --rm -p 21:21 -p 21100-21110:21100-21110 \
  -e PASV_ADDRESS='172.16.0.10' \
  -v /mnt/ftp:/_/data \
  -v ~/certs/:/etc/ssl/private/
  local/vsftpd:latest /bin/sh
```

default user:pass -> abc:abc  
default PUID:PGID -> 1000:1000

### all env options available
```bash
docker run -it --rm -p 21:21 -p 21100-21110:21100-21110 \
  -e PASV_ADDRESS='172.16.0.10' \
  -e PUID=1001
  -e PGID=1001
  -e USER=ftp
  -e PASS=ftp
  -v /mnt/ftp:/_/data \
  -v ~/certs/:/etc/ssl/private/
  local/vsftpd:latest /bin/sh
```

### iptables rules required (only if you use iptables)
```bash
sudo iptables -A INPUT -p tcp --dport 21 -j ACCEPT
sudo iptables -A INPUT -p tcp -m multiport --dports 21100:21110 -j ACCEPT
```
dont forget to open this ports in case you use other firewall

### client test
```bash
lftp -d -u ftp -e 'set ftp:ssl-force true' 172.16.0.10
```

### FAQ
* ```/_/data``` is the root for the FTP, must mapped ouside the container for persistence storage
* ```PASV_ADDRESS``` is **REQUIRED**, must be the IP of host running docker
* FTP server is in passive mode, meaning port 21 is for connection, data is sent on port range 21100-21110
* anonymous login/access is disabled
* vsftpd logs are sent to STDOUT to be availble through container logs
