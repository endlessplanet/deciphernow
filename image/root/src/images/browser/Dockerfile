FROM fedora:26
RUN \
    dnf update --assumeyes && \
    dnf install --assumeyes chromium && \
    dnf update --assumeyes && \
    adduser user && \
    dnf update --assumeyes && \
    dnf clean all
USER user
VOLUME /home
WORKDIR /home/user
ENTRYPOINT ["chromium-browser"]
CMD []
LABEL domain="deciphernow" title="browser"