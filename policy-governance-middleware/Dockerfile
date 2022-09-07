FROM node:18.3.0-alpine3.16

WORKDIR /usr/app

COPY . .

RUN npm install

ENV SERVER_PORT="8099"
ENV ANUBIS_API_URI="127.0.0.1:8085"

CMD [ "node", "src/main.js" ]
