#syntax=docker/dockerfile:1.4

ARG CLUSTER_PROJECT
FROM europe-docker.pkg.dev/${CLUSTER_PROJECT}/docker-hub-mirror/node:22-alpine AS build-env

WORKDIR /src
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# runtime stage
ARG CLUSTER_PROJECT
FROM europe-docker.pkg.dev/${CLUSTER_PROJECT}/docker-hub-mirror/node:22-alpine
WORKDIR /app

RUN chown -R 1000:1000 /app

COPY --from=build-env /src/package*.json ./
COPY --from=build-env /src/node_modules ./node_modules
COPY --from=build-env /src/dist ./dist

EXPOSE 3000
CMD ["node", "dist/index.js"]
