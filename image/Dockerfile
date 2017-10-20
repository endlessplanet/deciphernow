FROM docker:17.10.0
COPY root /opt/docker/
RUN ["sh", "/opt/docker/scripts/run.sh"]
USER user
VOLUME /home
WORKDIR /home/user
ENTRYPOINT ["sh", "/opt/docker/scripts/entrypoint.sh"]