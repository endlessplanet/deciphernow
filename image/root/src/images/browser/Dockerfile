FROM urgemerge/chromium-pulseaudio@sha256:21d8120ff7857afb0c18d4abf098549de169782e652437441c3c7778a755e46f
RUN \
    apt-get update --assume-yes && \
    adduser --disabled-password --gecos "" -G audio user && \
    chown user:user /data && \
    apt-get update --assume-yes && \
    apt-get clean all
USER user
VOLUME /home
WORKDIR /home/user
ENTRYPOINT ["chromium", " --user-data-dir=/data"]
CMD []
