#!/bin/bash

spring init product-service \
  --boot-version 2.3.4 \
  --build gradle \
  --java 11 \
  --packaging jar \
  --name product-service \
  --package-name com.fabijanbajo.products \
  --groupId com.fabijanbajo \
  --dependencies actuator,webflux,data-r2dbc
