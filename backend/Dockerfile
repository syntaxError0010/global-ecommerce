# Use a lightweight Node.js image
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy package files first
COPY package*.json ./

# Install dependencies (from the local package.json)
RUN npm install

# Copy your server.js into the image
COPY server.js .

# Expose the port
EXPOSE 3000

# Start the application
CMD [ "node", "server.js" ]