FROM node:8-alpine

WORKDIR /src

ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

ENV RUN_TESTS='NODE_ENV=development && npm install --silent && npm test'

RUN npm config set strict-ssl true && \
    npm config set registry https://artifacts.sub.rocks/repository/npm-group/

COPY package*.json /src/

RUN npm install --silent && npm cache clean --force

COPY . /src

CMD [ "node", "." ]
