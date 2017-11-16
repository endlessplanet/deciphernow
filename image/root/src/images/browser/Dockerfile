FROM urgemerge/chromium-pulseaudio@sha256:21d8120ff7857afb0c18d4abf098549de169782e652437441c3c7778a755e46f
RUN \
    apt-get update --assume-yes && \
    apt-get install --assume-yes sudo && \
    adduser --disabled-password --gecos "" user && \
    echo "user ALL=(ALL) NOPASSWD: /entrypoint.sh" > /etc/sudoers.d/user && \
    chmod 0444 /etc/sudoers.d/user &&
    apt-get update --assume-yes && \
    apt-get clean all
USER user
VOLUME /home
WORKDIR /home/user
ENTRYPOINT ["sudo", "/entrypoint.sh"]
CMD []
