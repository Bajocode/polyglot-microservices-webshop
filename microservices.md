## Services

## Ideas
* docs
  * red markers books
  * diagrams
    * c4, defined boundaries and infra 
  * all patterns
    * repository
    * data mapper
    * dependency injection
    * logging
    * error handling
    * indexing
    * storing in s3
    * base entities with created-at etc, version
    * non-blocking synchonous api vs asynchronous service
  * next steps
    * async event driven create, update, delete 

## Project
* ops
  * docker
  * kubernetes/chart
  * skaffold
  * docker-compose
* project
  * readme
    * https://structurizr.com/share/4241/diagrams#Containers
    * boundaries: DDD
  * services/
  * ios/
  * react/

## Services
### Domains 
* cart-service
  * go
  * redis
* order-service
  * java
  * postgres
* payment-service
  * swift
  * stripe
* product-service
  *  (built in REST, streaming)
  * `“implementation('org.springframework.cloud:spring-cloud-starter-stream-rabbit')”`
  * postgres
* user-service
  * typescript
  * postgres
* search-service
  * python 
  * elasticsearch

### Service
* dev
  * logger with format
  * graceful shutdown
  * config management
  * patterns
    * dependency injection 
  * data
    * entities
    * repositories
  * javadoc / jsdoc / godoc / swiftdoc / pydoc
  * testing from books: go FS, java, enterpise
  * health
* ops
  * docker
  * kubernetes/chart
  * skaffold
  * docker-compose
* project
  * readme
