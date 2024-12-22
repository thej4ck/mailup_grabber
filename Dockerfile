FROM node:20-alpine3.19

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production

COPY . .

EXPOSE 3000

USER node

CMD ["node", "app.js"]