FROM alpine:3.13
RUN apk add --no-cache vsftpd=3.0.3-r6

COPY ["vsftpd.conf", "/etc/vsftpd/vsftpd.conf"]
COPY ["entrypoint.sh", "/"]

EXPOSE 21/tcp 
EXPOSE 21100-21110/tcp

ENTRYPOINT ["/entrypoint.sh"]
