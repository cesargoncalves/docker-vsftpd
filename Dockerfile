FROM alpine:3.14
RUN apk add --no-cache vsftpd

COPY ["vsftpd.conf", "/etc/vsftpd/vsftpd.conf"]
COPY ["entrypoint.sh", "/"]

EXPOSE 20/tcp 
EXPOSE 21/tcp 

ENTRYPOINT ["/entrypoint.sh"]
