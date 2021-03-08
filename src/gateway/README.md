# Gateway
API Gateway that forwards clients to the micro-services, handles JWT validation,
terminates tls and transforms url paths

## Prerequisites
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
###### Kubernetes
This is an unsupported helm chart I created myself because I couldn't find any

```sh
# skaffold
skaffold run

# or through helm
helm upgrade \
  --install cart-service ./kubernetes/catalog-service \
  -f kubernetes/cart-service/values.yaml

```

## Usage
See the [krakend.io docs](https://www.krakend.io/docs/overview/introduction/)
