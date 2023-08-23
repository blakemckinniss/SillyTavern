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

# Cleanup unnecessary files
RUN \
  echo "*** Cleanup ***" && \
  mv "./docker/docker-entrypoint.sh" "./" && \
  rm -rf "./docker" && \
  echo "*** Make docker-entrypoint.sh executable ***" && \
  chmod +x "./docker-entrypoint.sh" && \
  echo "*** Convert line endings to Unix format ***" && \
  dos2unix "./docker-entrypoint.sh" && \
  echo "*** LIST CURRENT DIRECTORY ***" && \
  ls public

RUN \
  rm -rf "public" && \
  ln -s "/blake/public" "public" && \
  mkdir "config" && \
  IFS="," RESOURCES="characters,chats,groups,group chats,User Avatars,worlds,settings.json" && \
  for R in $RESOURCES; do ln -s "../config/$R" "public/$R"; done && \

EXPOSE 8000

CMD [ "./docker-entrypoint.sh" ]
