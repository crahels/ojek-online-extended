FROM node:boron-alpine

RUN apk add --no-cache make gcc g++ python libc6-compat

# Create app directory and set as working directory
RUN mkdir -p /opt/ChatService
RUN chown -R node:node /opt/ChatService
WORKDIR /opt/ChatService

# Use default node (non-root) user
USER node

# Install app dependencies (done before copying app source to optimize caching)
COPY ["package.json", "npm-shrinkwrap.json*", "yarn.lock*", "/opt/ChatService"]

RUN npm install --quiet

# Copy app source to container
COPY . /opt/ChatService

EXPOSE 3000
CMD ["npm", "start"]
