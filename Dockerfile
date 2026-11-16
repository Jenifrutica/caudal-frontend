# PWA de CAUDAL servida con nginx, para el arranque local con un comando (caudal-backend: make up).
# Producción sigue en Vercel (vercel.json); esta imagen replica sus cabeceras y su fallback SPA.
# Uso directo:
#   docker build --build-arg VITE_API_BASE_URL=http://localhost:8080/api/v1 -t caudal-web:local .
#   docker run --rm -p 8081:8080 caudal-web:local

ARG NODE_IMAGE=node:24-bookworm-slim
ARG NGINX_IMAGE=nginxinc/nginx-unprivileged:1.29-alpine

FROM ${NODE_IMAGE} AS build
WORKDIR /app
RUN corepack enable
COPY package.json pnpm-lock.yaml ./
RUN --mount=type=cache,target=/root/.local/share/pnpm/store \
    pnpm install --frozen-lockfile
COPY . .
# La URL de la API se fija en el build (Vite la incrusta en el bundle).
ARG VITE_API_BASE_URL=http://localhost:8080/api/v1
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}
RUN pnpm build

FROM ${NGINX_IMAGE} AS runtime
ARG VITE_API_BASE_URL=http://localhost:8080/api/v1
COPY docker/nginx.conf.template /etc/nginx/templates/default.conf.template
COPY --from=build /app/dist /usr/share/nginx/html
# El origen de la API entra en connect-src de la CSP (igual que en vercel.json).
ENV API_ORIGIN=http://localhost:8080
EXPOSE 8080
