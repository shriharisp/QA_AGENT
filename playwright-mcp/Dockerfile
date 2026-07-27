FROM mcr.microsoft.com/playwright:v1.49.1-noble

WORKDIR /app

# Copy dependency files
COPY package.json ./

# Install npm dependencies & playwright browser binaries
RUN npm install
RUN npx playwright install chromium --with-deps

# Copy application source code
COPY index.js ./

# Expose SSE port
EXPOSE 8931

ENV PORT=8931
ENV NODE_ENV=production

CMD ["npm", "start"]
