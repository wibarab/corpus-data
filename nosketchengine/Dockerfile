FROM ghcr.io/acdh-oeaw/noske-ubi9/noske:latest
LABEL maintainer omar.siam@oeaw.ac.at

ENV CORPLIST=wibarab-corpus-data \
    LANG=C.UTF8
COPY 130_vert_plain/ /var/lib/manatee/data/verticals/wibarab-corpus-data/
COPY nosketchengine/wibarab-corpus-data /var/lib/manatee/registry/wibarab-corpus-data
# Build will not save anything in /var/lib/manatee/data/ as this is defined as VOLUME
USER root
RUN path=$(grep -h ^PATH $MANATEE_REGISTRY/$CORPLIST | sed -e 's/^PATH[^"]*"\(.*\)"$/\1/g'); \
    mkdir -p $path && (compilecorp $CORPLIST || /bin/true) &&\
    mkdir -p /data.precompiled &&\
    mv $path /data.precompiled/ &&\
    chown -R www-data:www-data /data.precompiled
USER www-data
CMD ["/bin/sh", "-c", "mv /data.precompiled/* /var/lib/manatee/data; exec /bin/sh /run_lighttpd.sh"]
