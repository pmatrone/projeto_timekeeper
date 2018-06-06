FROM postgres
EXPOSE 5432 
COPY *.sql *.sh /docker-entrypoint-initdb.d/
ENV POSTGRES_USER=postgres POSTGRES_PASSWORD=redhat99