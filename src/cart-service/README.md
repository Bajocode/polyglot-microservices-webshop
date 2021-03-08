# Cart Service
Manages shopping carts for **registered** customers

## Prerequisites
###### Local
go
```
brew install go
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
go install

# run with local cache
LOCAL_STORE_ENABLED=true cart-service

# run with external cache
docker-compose up -d && cart-service
```

###### Kubernetes
```sh
# skaffold
skaffold run

# or through helm
helm upgrade \
  --install cart-service ./kubernetes/catalog-service \
  -f kubernetes/cart-service/values.yaml

# or make (requires make)
cat ./Makefile
make publish
```

## Usage
See swagger
