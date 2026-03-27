FROM minio/mc:latest

COPY bootstrap.sh /usr/local/bin/bootstrap.sh

RUN chmod +x /usr/local/bin/bootstrap.sh

ENTRYPOINT ["/usr/local/bin/bootstrap.sh"]
