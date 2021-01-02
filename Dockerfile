FROM node:15-alpine as models

RUN apk add --no-cache git \
 && git clone https://github.com/ClementD64/tachiyomi-protobuf-models.git models \
 && cd models \
 && git clone https://github.com/tachiyomiorg/tachiyomi.git \
 && node generate-models.js tachiyomi.proto

FROM node:15-alpine

ENV TACHIYOMI_LISTEN_PORT=80
ENV TACHIYOMI_BACKUP=/backup
ENV TACHIYOMI_COVER_CACHE=/tmp/cover-cache

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY --from=models /models/tachiyomi.proto ./tachiyomi.proto
COPY src src
COPY index.html index.html

EXPOSE 80
ENTRYPOINT [ "node", "src" ]
