# Use the official Node.js 24 Alpine image for a minimal and secure base
FROM node:24-alpine

# Set the environment to production
ENV NODE_ENV=production

# Set the working directory
WORKDIR /app

# Copy package files (good practice, even with zero current external dependencies)
COPY package.json package-lock.json* ./

# In case dependencies are added in the future, install production dependencies
RUN npm ci --only=production --ignore-scripts || true

# Copy the rest of the application files
COPY . .

# Create the data directory for SQLite and set ownership to the 'node' user
# so that the non-root 'node' user can read/write to the SQLite database
RUN mkdir -p /app/data && chown -R node:node /app

# Switch to the non-root 'node' user for security
USER node

# Expose the port the app runs on
EXPOSE 3000

# Define a volume for SQLite database persistence
VOLUME ["/app/data"]

# Start the application using Node directly to ensure signal handling works correctly
CMD ["node", "server.js"]
