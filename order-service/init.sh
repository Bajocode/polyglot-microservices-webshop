#!/bin/bash

spring init order-service \
  --boot-version 2.3.4 \
  --build gradle \
  --java 11 \
  --packaging jar \
  --name order \
  --package-name com.fabijanbajo.order \
  --groupId com.fabijanbajo \
  --dependencies actuator,webflux
