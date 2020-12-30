## TODO:
- created/updated autofields
- graceful
- probes
- secrets

## Flow

#### GET /catalog/products
```json
[
  {
    "productid": "b2076903-4447-4095-8854-c22ed31e4754",
    "name": "prod1",
    "price": 200
  },
  {
    "productid": "c260fc2e-3402-46b0-95b9-25b61d4224a1",
    "name": "prod2",
    "price": 4000
  },
  {
    "productid": "63dae3ae-64dc-4029-a87a-7cea7820b740",
    "name": "prod3",
    "price": 2050
  }
]
```

#### PUT /cart (soon header token)
```json
{
  "userId": "85a3a5d5-e50f-463b-a757-9acf5515644a",
  "items": [
    {
      "productid": "c260fc2e-3402-46b0-95b9-25b61d4224a1",
      "quantity": 1,
      "price": 4000
    },
    {
      "productid": "63dae3ae-64dc-4029-a87a-7cea7820b740",
      "quantity": 4,
      "price": 8200
    }
  ]
}
```

#### POST /orders
```json
{
  "userid": "85a3a5d5-e50f-463b-a757-9acf5515644a",
  "items": [
    {
      "productid": "c260fc2e-3402-46b0-95b9-25b61d4224a1",
      "quantity": 1,
      "price": 4000
    },
    {
      "productid": "63dae3ae-64dc-4029-a87a-7cea7820b740",
      "quantity": 4,
      "price": 8200
    }
  ],
  "price": 12200
}
```

#### POST /payments
```json
{
  "token": "",
  "customer_id": "",
  "product_id": "",
  "sell_price": 12200,
  "rememberCard": true,
  "useExisting": true
}
```

## Services

### Service
* crud 
* logger
  * format
  * logging all requests
* swagger
* global exception filters
* graceful shutdown
* health
* config
* javadoc / jsdoc / godoc / swiftdoc / pydoc
* docker
* kubernetes/chart
* skaffold
* docker-compose
* readme
* .gitignore
* testing
  * from books
  * repositories


## Project
* skaffold
* docker-compose
* readme
  * diagrams https://structurizr.com/share/4241/diagrams#Containers
  * boundaries
  * see red marked books
* microservices/
* ios/
* react/

## Services 
* cart-service
  * go
  * redis
* ordering-service
  * typescript
  * postgres
* payment-service
  * swift
  * stripe
* catalog-service
  * java
  * postgres
* user-service
  * typescript
  * postgres
* search-service
  * python 
  * elasticsearch

