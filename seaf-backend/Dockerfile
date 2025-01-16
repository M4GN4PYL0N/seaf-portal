# syntax=docker/dockerfile:1.3
ARG NODE_VERSION=20

FROM node:${NODE_VERSION}-alpine AS deps
WORKDIR /var/www
COPY seaf-archtool-core/package.json seaf-archtool-core/package-lock.json ./
COPY seaf-archtool-core/plugins ./plugins/
# RUN --mount=type=cache,target=/root/.npm npm install
RUN npm install



FROM node:${NODE_VERSION}-alpine AS builder
ARG VUE_APP_DOCHUB_ROLES_MODEL=n
ARG VUE_APP_DOCHUB_AUTHORITY_SERVER
ARG VUE_APP_DOCHUB_AUTHORITY_CLIENT_ID
ARG VUE_APP_PLANTUML_SERVER
WORKDIR /var/www
COPY --from=deps /var/www .
COPY seaf-archtool-core .
COPY --from=deps /var/www/plugins ./plugins/
ENV NODE_ENV=production
ENV VUE_APP_DOCHUB_MODE=backend
ENV VUE_APP_DOCHUB_ROLES_MODEL=$VUE_APP_DOCHUB_ROLES_MODEL
ENV VUE_APP_DOCHUB_AUTHORITY_SERVER=$VUE_APP_DOCHUB_AUTHORITY_SERVER
ENV VUE_APP_DOCHUB_AUTHORITY_CLIENT_ID=$VUE_APP_DOCHUB_AUTHORITY_CLIENT_ID
ENV VUE_APP_PLANTUML_SERVER=$VUE_APP_PLANTUML_SERVER

# RUN --mount=type=cache,target=./node_modules/.cache npm run build
RUN npm run build
CMD ["node", "src/backend/main.mjs"]
EXPOSE 3030