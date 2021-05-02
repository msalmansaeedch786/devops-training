FROM node:alpine

ARG dns

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY server.js ./

CMD npm start
