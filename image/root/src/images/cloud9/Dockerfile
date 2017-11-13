FROM fedora:25
COPY root /opt/docker/
RUN ["sh", "/opt/docker/scripts/run.root.sh"]
USER user
RUN ["sh", "/opt/docker/scripts/run.user.sh"]
VOLUME /home
WORKDIR /home/user
ENTRYPOINT ["sh", "/opt/docker/scripts/entrypoint.sh"]
CMD []
LABEL title="cloud9" domain="deciphernow"