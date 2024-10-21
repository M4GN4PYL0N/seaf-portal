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
ENV VUE_APP_DOCHUB_ROLES_MODEL = y
ENV VUE_APP_DOCHUB_ROLES = file:///workspace/roles/roles_default.yaml
ENV VUE_APP_DOCHUB_AUTHORITY_SERVER = http://archaaa.local:8082/realms/archportal
ENV VUE_APP_DOCHUB_AUTHORITY_CLIENT_ID = archportal
ENV VUE_APP_DOCHUB_AUTH_PUBLIC_KEY = -----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA9WhNBLOUKeq6xpPNfgZhhXDbEl+8bI3bTRBDdHFkAEmK6wIpSL1uvzlsvWFCoX79I7hZURUEj4zSaQ/7cD0Pe4z3VqnJKbXhcKBy552t3f/6vgBvMR2WQ4TVJIu8xWeGSghjs85nSJYK4boLzbb0SfZREoIE/EJYvCV/XJACHakq9hQcmAwJCPanPmFjibUpNdRJVTFMC/n/jKB2Q1PeeyNAS0Xuef6KvGQpjwydKgJD9WwAEnAj+24npgq7lUMiCJK18UcNQcbAEXtNSN1e3I9MK0h6Uv8sDJmMqz/MarWj9Q/Q/QyMBFr5i/hlgw7QgEjxSqvud7dFBlbE/JMk4QIDAQAB-----END PUBLIC KEY-----
# RUN --mount=type=cache,target=./node_modules/.cache npm run build
RUN npm run build
CMD ["node", "src/backend/main.mjs"]
EXPOSE 3030