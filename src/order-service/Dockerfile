FROM       node:12.19.0-alpine AS builder
USER       node
WORKDIR    /home/node
COPY       --chown=node:node package*.json ./
RUN        ["npm", "ci"]
COPY       --chown=node:node . .
RUN        npm run build && \
           npm run test && \
           find . \
           ! -name dist \
           ! -name package.json \
           ! -name package-lock.json \
           ! -name node_modules \
           -maxdepth 1 \
           -mindepth 1 \
           -exec rm -rf {} \;

FROM       node:12.19.0-alpine AS target
USER       node
WORKDIR    /home/node
COPY       --chown=node:node --from=builder /home/node .
EXPOSE     9003
ENTRYPOINT ["npm", "run", "serve"]
