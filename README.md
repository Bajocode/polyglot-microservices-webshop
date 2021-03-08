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
| [ios-frontend](./src/ios-frontend)         | Swift       | Mobile UI                                                    |
| [gateway](./src/gateway)                   | Helm / Yaml | Provides a single entry-point for all services, while provising cross-cutting features such as authentication, SSL termination and cache |
| [identity-service](./src/identity-service) | Typescript  | Acts as token issuer and handles user login and registration |
| [catalog-service](./src/catalog-service)   | Java        | Provides products and categories                             |
| [cart-service](./src/cart-service)         | Go          | A product and categories                                     |
| [order-service](./src/order-service)       | Typescript  | Creates orders and submits payment requests to the payment-service |
| [payment-service](./src/payment-service)   | Go          | Charges the order through Stripe payment-gateway             |
| [load-generator](./src/load-generator)     | Python      | Imitating realistic user shopping flows by continuously sending API requests |

###### Authentication
![design-system](./media/design-auth.svg)

###### Frontend
![design-system](./media/design-ios.svg)

###### Technologies
* docker
* k8s
* helm
* prometheus
* skaffold
* grafana
* iOS
* locust
* concourse ci
* stripe

## Getting Started
###### Prerequisites
* docker
* xcode
* skaffold

###### Installing
* k8s
* compose

###### Running
* skaffold run

## Roadmap
* async message passing
* images and object-store (minio)
* service bus architecture with RabbitMQ
* end to end testing
* payment with tokens
* react front-end
