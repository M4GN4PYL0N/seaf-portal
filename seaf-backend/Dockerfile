# syntax=docker/dockerfile:1.3
ARG NODE_VERSION=20

FROM node:${NODE_VERSION}-alpine AS deps
WORKDIR /var/www
COPY seaf-archtool-core/package.json seaf-archtool-core/package-lock.json ./
COPY seaf-archtool-core/plugins ./plugins/
# RUN --mount=type=cache,target=/root/.npm npm install
RUN npm install



FROM node:${NODE_VERSION}-alpine AS builder
WORKDIR /var/www
COPY --from=deps /var/www .
COPY seaf-archtool-core .
COPY --from=deps /var/www/plugins ./plugins/
ENV NODE_ENV=production
ENV VUE_APP_DOCHUB_MODE=backend
ENV VUE_APP_DOCHUB_ROLES_MODEL=y
ENV VUE_APP_DOCHUB_AUTHORITY_SERVER=https://aaa.archportal.local/realms/archportal
# ENV VUE_APP_DOCHUB_AUTHORITY_CLIENT_ID=archportal
# ENV VUE_APP_DOCHUB_AUTH_PUBLIC_KEY="-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3vQQfcfSayGGkEXJQIrVrXIl8iK3/AnwV4KkR2G5T1Ka6abBEosbVJS2kS09Fxo84AuFb3jgbXGYJvMiisBTdK5Q3nUqZZGoapR9AkIx5LKTWAAQF5QYc+vUIDZoX5S1MnTdnOGvP8j4jZpH5fgnwc4mXKrxuxWBYEsJiI9lP9rAvowWUKQ7z+AAvqXDFbdymxxsWYPXe092GcOY1PWOmNal8DJxA64uRqWzCb7RYVUMD8nfT5pKfhrka3sCE/gYPSsvxT5s3NSi8fETHi6MdtvXtdNReapJ95ngPoeh9Ug52pk8TiAwmTvi1c25c1vxTYF9QkJLae8WZy4XQDIuHwIDAQAB-----END PUBLIC KEY-----"

# RUN --mount=type=cache,target=./node_modules/.cache npm run build
RUN npm run build
CMD ["node", "src/backend/main.mjs"]
EXPOSE 3030