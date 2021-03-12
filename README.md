# Polyglot Sample Microservices Application
Simplified cloud-native ecommerce application hosted on Kubernetes, allowing users to browse products and submit orders through an iOS frontend. The goal of the project is to experiment with languages, frameworks and architectures

## Table of Contents
1. Architecture
2. Getting Started
3. Roadmap
4. Contact

## Architecture
![design-system](./media/design-system.svg)

| Service                                    | Language    | Description                                                  |
| ------------------------------------------ | ----------- | ------------------------------------------------------------ |
| [frontend-ios](./src/frontend-ios)         | Swift       | Mobile UI                                                    |
| [gateway](./src/gateway)                   | Helm / Yaml | API Gateway that forwards clients to the micro-services, handles JWT validation, terminates tls and transforms url paths |
| [identity-service](./src/identity-service) | Typescript  | Manages customer accounts and signs JWTs (symmetric HMAC), while hosting a JSON Web Key set (JWK) to offload authorization |
| [catalog-service](./src/catalog-service)   | Java        | Manages a catalog of products and categories |
| [cart-service](./src/cart-service)         | Go          | Manages shopping carts for **registered** customers |
| [order-service](./src/order-service)       | Typescript  | Manages **complete** orders for **registered** customers based on shopping carts |
| [payment-service](./src/payment-service)   | Go          | Manages payments based on orders from **registered** customers, offloading payment processing to the Stripe payment gateway |
| [load-generator](./src/load-generator)     | Python      | Generates artificial load using Python config files |

###### Authentication
![design-system](./media/design-auth.svg)

###### Frontend iOS
![design-system](./media/design-ios.svg)

###### Technologies
* ops
  * k8s
  * helm
  * prometheus
  * skaffold
  * grafana
  * docker
  * concourse ci
* dev
  * iOS
  * locust
  * stripe

## Getting Started
### Kubernetes
###### Local Vagrant + Ansible
###### Local Docker for Desktop
###### Terraform (AWS, GCP, IBM)

### Docker Compose
###### Running

### Tests
Run basic tests to verify build and deployment with an e2e test bash script
> [e2e_test.sh](./e2e_test.sh): (simplified contract test framework I've written in bash)

```sh
cd root
./e2e_test.sh
```
![e2e-test](./media/e2e-test.png)


## Roadmap
* async message passing
* images and object-store (minio)
* service bus architecture with RabbitMQ
* end to end testing
* payment with tokens
* react front-end

## Contact
Fabijan Bajo - [linkedIN](https://www.linkedin.com/in/fabijanbajo/) - [email](mailto:bajo09gmail.com)

Project link: [https://github.com/Bajocode/polyglot-microservices-webshop](https://github.com/Bajocode/polyglot-microservices-webshop)
