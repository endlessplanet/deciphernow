FROM fedora:26
RUN \
    dnf update --assumeyes && \
    dnf install --assumeyes openssh-server && \
    dnf update --assumeyes && \
    dnf clean all
ENTRYPOINT ["bash"]
CMD []