FROM panubo/sshd
COPY root /opt/docker
RUN ["sh", "/opt/docker/scripts/run.sh"]
ENTRYPOINT ["sh", "/opt/docker/scripts/entrypoint.sh"]
CMD []