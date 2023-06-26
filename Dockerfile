# Use the official lightweight Node.js 16 image.
# https://hub.docker.com/_/node
FROM node:16-slim

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy local code to the container image.
COPY . .

# Expose port 80
EXPOSE 80

# Run the web service on container startup.
CMD [ "node", "app.js" ]