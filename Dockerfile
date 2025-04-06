FROM node:16-alpine

WORKDIR /app

# Install Medusa CLI globally
RUN npm install -g @medusajs/medusa-cli

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --production  # Using --production to only install required dependencies

# Copy the rest of the application
COPY . .

# Expose the port
EXPOSE 9000

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:9000/health || exit 1

# Run migrations and start the application
CMD medusa migrations run && npm run start
