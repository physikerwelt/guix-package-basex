FROM eclipse-temurin:21
WORKDIR /basex
COPY ./basex /basex
EXPOSE 8081
CMD [ "/basex/bin/basexhttp" , "-cPASSWORD" ]
