FROM evertongava/core-alpine:3.16.2
LABEL maintainer="Everton Gava <evertongava@mabalus.com>"

ARG GRAFANA_VERSION=9.3.6
ARG GRAFANA_DIR="/usr/share/grafana"
ARG GRAFANA_PACKAGE="grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz"
ARG GRAFANA_REPO="https://dl.grafana.com/oss/release/${GRAFANA_PACKAGE}"

WORKDIR /tmp

RUN set -ex \
	&& apk add --no-cache --update gcompat \
		&& mkdir -p \
		/var/data/grafana \
		/var/log/grafana \
		${GRAFANA_DIR}/plugins \
	&& wget -q ${GRAFANA_REPO} \
	&& tar zxf "${GRAFANA_PACKAGE}" -C "${GRAFANA_DIR}" --strip 1 \
	&& rm -f ${GRAFANA_PACKAGE} \
	&& ln -s ${GRAFANA_DIR}/bin/grafana-server /usr/bin/grafana-server \
	&& ln -s ${GRAFANA_DIR}/bin/grafana-cli /usr/bin/grafana-cli \
	&& cd /etc/ \
	&& ln -s ${GRAFANA_DIR}/conf/ grafana

COPY assets/* ${GRAFANA_DIR}/conf/

WORKDIR ${GRAFANA_DIR}

RUN chown -R app:adm \
		/etc/grafana/ \
		${GRAFANA_DIR}/ \
		/var/data/grafana \
		/var/log/grafana \
	&& chmod -R 755 \
		${GRAFANA_DIR}/ \
		/var/data/grafana \
		/var/log/grafana

EXPOSE 3000

USER app

CMD [ "grafana-server", \ 
	"-homepath", \ 
	"/usr/share/grafana/", \ 
	"-config", \ 
	"/etc/grafana/defaults.ini" ]