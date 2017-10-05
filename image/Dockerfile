FROM docker:17.09.0
COPY root /opt/docker/
RUN ["sh", "/opt/docker/run.sh"]
USER user
ENV \
    SSHD_IMAGE="endlessplanet/sshd:ca675205de9d945aac60f35885ae75a71f9de123" \
    CLOUD_IMAGE="endlessplanet/cloud9:a5622dbf945f91fa6c47e38276b34e5babb5e019"
ENTRYPOINT ["sh", "/opt/docker/entrypoint.sh"]
CMD []