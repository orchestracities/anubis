FROM node:18.3.0-alpine3.16

WORKDIR /usr/app

COPY . .

RUN npm install
RUN npm install pm2@5.2.0 -g

EXPOSE 49662
EXPOSE 8099

CMD [ "node", "src/main.js" ]
