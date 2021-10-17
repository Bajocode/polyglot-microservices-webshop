FROM      node:12.19.0 AS builder
USER      node
WORKDIR   /home/node
COPY      --chown=node:node package*.json ./
RUN       ["npm", "clean-install"]
COPY      --chown=node:node . .
RUN       ["npm",  "run", "test"]

FROM      node:12.19.0-alpine AS target
USER      node
WORKDIR   /home/node
COPY      --chown=node:node --from=builder /home/node .
EXPOSE    3000
ENTRYPOINT  ["npm", "run", "serve"]
