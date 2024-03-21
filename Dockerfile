# Use LTS version of node as base
FROM node:lts-alpine AS build

# Create app directory
WORKDIR /app

# Change ownership to non-root user for security
RUN chown -R node:node .
USER node

# Install app dependencies

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY --chown=node:node package*.json ./

# Install dependencies in a separate layer to take advantage of Docker layer caching
RUN npm ci

# Bundle package sources 
COPY --chown=node:node lib/ ./lib/
COPY --chown=node:node specs/ ./specs/
COPY --chown=node:node tldr.l tldr.yy ./

# Build and test the application
RUN npm run jison
RUN npm run test

# Set the command to be executed when running the Docker container. This will start the application.
ENTRYPOINT ["node", "lib/tldr-lint-cli.js"]
