FROM eclipse-temurin:21
WORKDIR /basex
COPY ./basex /basex
EXPOSE 8081
CMD [ "sh", "-c", "/basex/bin/basexhttp -c \"PASSWORD ${basexpassword}\"" ]
