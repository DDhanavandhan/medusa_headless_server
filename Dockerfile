# Stage 1: Build the application
FROM node:16-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build the application if needed
# RUN npm run build

# Stage 2: Run the application(production)
FROM node:16-alpine

# Set working directory
WORKDIR /app

# Install Medusa CLI globally again
RUN npm install -g @medusajs/medusa-cli

# Copy the built application from the build stage
COPY --from=build /app .

# Expose the port the app runs on
EXPOSE 9000

# Run migrations and then start the application
CMD medusa migrations run && npm run start
