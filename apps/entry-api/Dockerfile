FROM node:16 as base
WORKDIR /app
COPY package*.json ./

FROM base as builder
COPY . ./
RUN npm install && npm run build

FROM base as runtime
COPY --from=builder /app/dist ./
RUN npm install --production
CMD ["node", "index.js"]