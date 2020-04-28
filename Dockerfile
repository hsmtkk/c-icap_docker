FROM centos:8 as builder

RUN yum -y update \
 && yum -y install gcc make

WORKDIR /usr/local/src

RUN curl -L -o c_icap-0.5.6.tar.gz "https://ja.osdn.net/frs/g_redir.php?m=kent&f=c-icap%2Fc-icap%2F0.5.x%2Fc_icap-0.5.6.tar.gz" \
 && tar fxz c_icap-0.5.6.tar.gz \
 && cd c_icap-0.5.6 \
 && ./configure --prefix=/usr/local \
 && make \
 && make install

WORKDIR /usr/local/src

RUN curl -L -o c_icap_modules-0.5.4.tar.gz "https://ja.osdn.net/frs/g_redir.php?m=kent&f=c-icap%2Fc-icap-modules%2F0.5.x%2Fc_icap_modules-0.5.4.tar.gz" \
 && tar fxz c_icap_modules-0.5.4.tar.gz \
 && cd c_icap_modules-0.5.4 \
 && ./configure --prefix=/usr/local \
 && make \
 && make install

RUN rm -rf /usr/local/src/*

FROM centos:8

COPY --from=builder /usr/local /usr/local

RUN c-icap -VV

EXPOSE 1344
