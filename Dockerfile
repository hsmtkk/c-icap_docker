FROM ubuntu:20.04 as builder

RUN apt -y update \
 && apt -y install curl gcc make

WORKDIR /usr/local/src

RUN curl -L -o c_icap-0.5.6.tar.gz "https://ja.osdn.net/frs/g_redir.php?m=kent&f=c-icap%2Fc-icap%2F0.5.x%2Fc_icap-0.5.6.tar.gz" \
 && tar fxz c_icap-0.5.6.tar.gz \
 && cd c_icap-0.5.6 \
 && ./configure --prefix=/usr/local/c-icap \
 && make \
 && make install

WORKDIR /usr/local/src

RUN curl -L -o c_icap_modules-0.5.4.tar.gz "https://ja.osdn.net/frs/g_redir.php?m=kent&f=c-icap%2Fc-icap-modules%2F0.5.x%2Fc_icap_modules-0.5.4.tar.gz" \
 && tar fxz c_icap_modules-0.5.4.tar.gz \
 && cd c_icap_modules-0.5.4 \
 && ./configure --prefix=/usr/local/c-icap --with-c-icap=/usr/local/c-icap \
 && make \
 && make install

FROM ubuntu:20.04

COPY --from=builder /usr/local/c-icap /usr/local/c-icap

RUN /usr/local/c-icap/bin/c-icap -VV
