# Build stage/
FROM node:20-alpine AS build
RUN npm config set registry https://mirrors.cloud.tencent.com/npm/

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

# add .env to .env
RUN [ ! -e ".env" ] && cp .env .env || true

RUN npm run build

# Nginx stage
FROM nginx:1.27-alpine-slim AS app
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
