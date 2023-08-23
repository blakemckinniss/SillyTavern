FROM node:19.1.0-alpine3.16

# Arguments
ARG APP_HOME=/home/node/app

# Install system dependencies
RUN apk add gcompat tini git

# Ensure proper handling of kernel signals
ENTRYPOINT [ "tini", "--" ]

# Create app directory
WORKDIR ${APP_HOME}

# Install app dependencies
COPY package*.json ./
RUN \
  echo "*** Install npm packages ***" && \
  npm install && npm cache clean --force

# Bundle app source
COPY . ./

RUN \
  IFS="," RESOURCES="characters,chats,groups,group chats,User Avatars,worlds" && \
  \
  for R in $RESOURCES; do \
    if [ ! -d "/blake/public/$R" ]; then \
      mv "public/$R" "/blake/public/$R.default"; \
    fi; \
  done && \
  \
  rm -rf "public" && \
  ln -s "/blake/public" "public" && \
  mkdir "config"

# Cleanup unnecessary files
RUN \
  echo "*** Cleanup ***" && \
  mv "./docker/docker-entrypoint.sh" "./" && \
  rm -rf "./docker" && \
  echo "*** Make docker-entrypoint.sh executable ***" && \
  chmod +x "./docker-entrypoint.sh" && \
  echo "*** Convert line endings to Unix format ***" && \
  dos2unix "./docker-entrypoint.sh"

EXPOSE 8000

CMD [ "./docker-entrypoint.sh" ]
