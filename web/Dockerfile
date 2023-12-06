FROM fholzer/nginx-brotli

# 1000 is the default value if nothing is passed in though build args in docker-compose.yml
ARG UID=1000
ARG GID=1000

# Create user and group for given uid and gid
RUN if ! getent group docker; then addgroup -g ${GID} docker; \
    adduser -u ${UID} -h /home/docker -D docker -G docker; fi

# Run nginx as docker user
RUN sed -i "s/user  nginx/user  docker/g" /etc/nginx/nginx.conf

# Set the correct PHP backend
COPY nginx.default.conf.tmpl /etc/nginx/conf.d/default.conf
RUN sed -i "s/\${COMPOSE_PROJECT_NAME}/${COMPOSE_PROJECT_NAME}/g" /etc/nginx/conf.d/default.conf
RUN sed -i "s/\${TYPO3_CONTEXT}/${TYPO3_CONTEXT}/g" /etc/nginx/conf.d/default.conf
