FROM fedora:26
COPY root /opt/docker/
RUN ["sh", "/opt/docker/scripts/run.root.sh"]
USER user
VOLUME /home
WORKDIR /home/user
RUN ["sh", "/opt/docker/scripts/run.user.sh"]
ENTRYPOINT ["sh", "/opt/docker/scripts/entrypoint.sh"]
CMD []