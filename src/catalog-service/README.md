# Catalog Service
Manages a catalog of products and categories

## Prerequisites
###### Local
java11
```sh
brew install java11
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
./gradlew build

docker-compose up -d

java -jar build/libs/*jar
```

###### Kubernetes
```sh
# skaffold
skaffold run

# or through helm
helm upgrade \
  --install catalog-service ./kubernetes/catalog-service \
  -f kubernetes/catalog-service/values.yaml

# or make (requires make)
cat ./Makefile
make publish
```

## Usage
See swagger
