FROM nvidia/cuda:9.0-base-ubuntu16.04
LABEL maintainer="skinlayers@gmail.com"

ENV VERSION 0.3.4b
ENV ARCHIVE_NAME Zec.miner.${VERSION}.Linux.Bin.tar.gz
ENV GITHUB_URL https://github.com/nanopool/ewbf-miner/releases/download/v${VERSION}/${ARCHIVE_NAME}
ENV SHA256 b5c7ab47a9e7a9c60708075f247ec5e40135ba6c4f6219e5a52fea2ad6b433d8

WORKDIR /usr/local/bin
RUN set -eu && \
    adduser --system --home /data --group miner && \
    apt-get update && apt-get -y install --no-install-recommends curl ca-certificates && \
    curl -L "$GITHUB_URL" -o "$ARCHIVE_NAME" && \
    echo "$SHA256  $ARCHIVE_NAME" > "${ARCHIVE_NAME}_sha256.txt" && \
    sha256sum -c "${ARCHIVE_NAME}_sha256.txt" && \
    tar xf "$ARCHIVE_NAME" && \
    rm "$ARCHIVE_NAME" && \
    apt-get purge -y --auto-remove curl ca-certificates && \
    rm -r /var/lib/apt/lists/*

ENV GPU_FORCE_64BIT_PTR 0
ENV GPU_MAX_HEAP_SIZE 100
ENV GPU_USE_SYNC_OBJECTS 1
ENV GPU_MAX_ALLOC_PERCENT 100
ENV GPU_SINGLE_ALLOC_PERCENT 100

COPY ./docker-entrypoint.sh /

RUN chmod 0755 /docker-entrypoint.sh

USER miner

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/bin/miner"]
