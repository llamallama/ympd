FROM alpine:latest
RUN apk add --no-cache g++ make cmake libmpdclient-dev openssl-dev git
RUN git clone https://github.com/notandy/ympd.git /app/

RUN mkdir /app/build
WORKDIR /app/build
RUN cmake ..
RUN make

FROM alpine:latest

ENV MPDHOST=localhost
ENV MPDPORT=6600

RUN adduser ympd -u 9003 -D
RUN apk add  --no-cache libmpdclient openssl
EXPOSE 8080
COPY --from=0 /app/build/ympd /usr/bin/ympd
COPY --from=0 /app/build/mkdata /usr/bin/mkdata

USER ympd
ENTRYPOINT ympd -h ${MPDHOST} -p ${MPDPORT}
