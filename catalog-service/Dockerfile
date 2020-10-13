FROM       gcr.io/fabijanbajo/node-base:12.16.1-alpine AS build
USER       node
WORKDIR    /home/node
COPY       --chown=node:node package*.json ./
RUN        ["npm", "ci"]
COPY       --chown=node:node . .
RUN        npm run build && \
           npm run test:cov && \
           find . \
           ! -name dist \
           ! -name package.json \
           ! -name package-lock.json \
           ! -name node_modules \
           -maxdepth 1 \
           -mindepth 1 \
           -exec rm -rf {} \;

FROM       gcr.io/fabijanbajo/node-base:12.16.1-alpine AS target
USER       node
WORKDIR    /home/node
COPY       --chown=node:node --from=build /home/node .
EXPOSE     9001/tcp
ENTRYPOINT ["node", "start:prod"]



