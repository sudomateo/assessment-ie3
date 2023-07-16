ARG NODE_VERSION=20.4.0

FROM node:${NODE_VERSION} AS base
WORKDIR /taskly-frontend
COPY package.json ./package.json
COPY package-lock.json ./package-lock.json
RUN npm clean-install
COPY . .
RUN npm run build

FROM nginx:1.25.1 AS production
COPY --from=base /taskly-frontend/dist /usr/share/nginx/html
