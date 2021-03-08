# Order Service
Manages **complete** orders for **registered** customers based on shopping carts

## Prerequisites
###### Local
nvm (node version manager)
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
```
node and npm (version defined in `.nvmrc`)
```sh
# cd to service root (../order-service)
nvm install
```
docker and docker-compose
```sh
brew install docker
brew install docker-compose
```

###### Kubernetes
kubectl
```sh
brew install kubectl
```
helm
```sh
brew install helm
```
skaffold
```sh
brew install skaffold
```

## Install
###### Local
```sh
npm i
docker-compose up
npm run watch
```

###### Kubernetes
```sh
# skaffold
skaffold run

# or through helm
helm upgrade \
  --install order-service ./kubernetes/catalog-service \
  -f kubernetes/order-service/values.yaml

# or make (requires make)
cat ./Makefile
make publish
```

## Usage
See swagger
