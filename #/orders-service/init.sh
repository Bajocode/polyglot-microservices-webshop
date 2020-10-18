#!/bin/bash

spring init order-service \
  --boot-version 2.3.4 \
  --build gradle \
  --java 11 \
  --packaging jar \
  --name orders \
  --package-name com.fabijanbajo.orders \
  --groupId com.fabijanbajo \
  --dependencies actuator,webflux
