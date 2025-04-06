# Use the official Node.js image as the base image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package.json package-lock.json ./

# Install project dependencies
RUN npm install

# Copy all project files to the container
COPY . .

# Build the TypeScript code (ensure tsconfig.json is copied)
RUN npm run build

# Expose the port on which Medusa will run
EXPOSE 9000

# Run the Medusa backend
CMD ["npm", "run", "start"]
