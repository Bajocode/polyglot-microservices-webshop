#!/bin/bash

spring init catalog-service \
  --boot-version 2.3.4 \
  --build gradle \
  --java 11 \
  --packaging jar \
  --name catalog-service \
  --package-name com.fabijanbajo.catalog \
  --groupId com.fabijanbajo \
  --dependencies actuator,webflux,data-r2dbc,postgresql
