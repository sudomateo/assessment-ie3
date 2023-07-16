ARG NODE_VERSION=20.4.0

FROM node:${NODE_VERSION} AS base
WORKDIR /taskly-backend
COPY package.json ./package.json
COPY package-lock.json ./package-lock.json
RUN npm clean-install
COPY . .
RUN npm run build

FROM node:${NODE_VERSION} AS production
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /taskly-backend
COPY --from=base /taskly-backend/package.json ./package.json
COPY --from=base /taskly-backend/package-lock.json ./package-lock.json
COPY --from=base /taskly-backend/dist ./dist
RUN npm clean-install --omit=dev
CMD ["npm", "run", "start"]
