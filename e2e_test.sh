#!/bin/bash

readonly BASE_URL="${BASE_URL:-http://127.0.0.1:8080}"
readonly DELAY_SECONDS="${DELAY_SECONDS:-1}"
readonly EARLY_EXIT="${EARLY_EXIT}"
readonly BLUE='\033[0;34m' RED='\033[0;31m' GREEN='\033[0;32m' NC='\033[0m'

function execute_request() {
  local method=$1 path=$2 body=$3

  curl "${BASE_URL}${path}" \
    -X "${method}" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    ${TOKEN:+"-HAuthorization: Bearer $TOKEN"} \
    -d "${body}" \
    -w "\n%{http_code}\n%{time_total}" \
    -s
}

function log_request() {
  local method=$1 path=$2 code=$3 duration=$4
  echo -e "\n${BLUE}${method} ${BASE_URL}${path} [${code}, ${duration}s]${NC}"
}

function assert_case() {
  local case_name=$1 want=$2 got=$3
  if [[ "${want}" == "${got}" ]]; then
    echo -e " ${GREEN}PASS ${case_name}${NC}"
  else
    echo -e " ${RED}${case_name}${NC}"
    echo "  - got: ${got}"
    echo "  - want: ${want}"
  fi
}

function test_case() {
  local path=$1 method=$2 body="${3:-""}" name=$4 want_code=$5 want_body=$6
  local res_curl got_code got_body dur

  res_curl=$(execute_request "${method}" "${path}" "${body}")

  IFS=$'\n' read -rd "" got_body got_code dur <<< "${res_curl}"

  log_request \
    "${method}" \
    "${path}" \
    "${got_code}" \
    "${dur}"
  assert_case \
    "(code): ${name}" \
    "${want_code}" \
    "${got_code}" \

  if [[ -n "${want_body}" ]]; then
    assert_case \
      "(body): ${want_body}" \
      "${want_body}" \
      "${got_body}"
  fi

  sleep "${DELAY_SECONDS}"
}

function get_token() {
  res_curl=$(execute_request \
    "POST" \
    "/auth/login" \
    '{"email": "test@test.com", "password": "test"}')

  IFS=$'\n' read -rd "" got_body got_code dur <<< "${res_curl}"

  TOKEN=$(echo "${got_body}" | jq -r .token)
}

function clear_database() {
  printf "\n purging users table..."

  kubectl exec \
    -it identity-service-postgresql-0 \
    -- sh \
    -c 'PGPASSWORD=admin psql -U postgres -d identity-service -c "DELETE from users"'
}

function test_auth() {
  clear_database

  test_case \
    "/auth/register" \
    "POST" \
    '{"email": "test@test.com", "password": "test"}' \
    "new email status 201" \
    201
  test_case \
    "/auth/register" \
    "POST" \
    '{"email": "test@test.com", "password": "test"}' \
    "duplicate email status 409" \
    409
  test_case \
    "/auth/register" \
    "POST" \
    '{"email": "testtest.com", "password": "test"}' \
    "wrong email format status 400" \
    400
  test_case \
    "/auth/login" \
    "POST" \
    '{"email": "test@test.com", "password": "test"}' \
    "good login 201" \
    201
  test_case \
    "/auth/login" \
    "POST" \
    '{"email": "testtest@test.com", "password": "test"}' \
    "nonexisting email 404" \
    404 \
    '{"status":404,"message":"User not found with email: testtest@test.com"}'
}

function test_catalog() {
  test_case \
    "/catalog/products" \
    "GET" \
    '' \
    "all products 200" \
    200
  test_case \
    "/catalog/products/1641ffa1-cb5d-4757-8965-bc063d66e11a" \
    "GET" \
    '' \
    "one products 200" \
    200
  test_case \
    "/catalog/categories" \
    "GET" \
    '' \
    "all categories 200" \
    200
}

function test_cart() {
  test_case \
    "/cart" \
    "GET" \
    '' \
    "get without existing cart 200" \
    200
  test_case \
    "/cart" \
    "PUT" \
    '{"items":[{"productid":"94e8d5de-2192-4419-b824-ccbe7b21fa6f","quantity":2,"price":200}]}' \
    "create filled cart 201" \
    201 \
    '{"items":[{"productid":"94e8d5de-2192-4419-b824-ccbe7b21fa6f","quantity":2,"price":200}]}'
  test_case \
    "/cart" \
    "GET" \
    '' \
    "get with existing cart 200" \
    200 \
    '{"items":[{"productid":"94e8d5de-2192-4419-b824-ccbe7b21fa6f","quantity":2,"price":200}]}'
}

function test_orders() {
  test_case \
    "/orders" \
    "POST" \
    '{"items":[{"quantity":5,"price":50050,"productid":"dac36ad3-99dd-482c-96b4-a95390029745","productid":"81ba794d-390a-464b-b60f-68add6cd9687"}],"price":200555 }' \
    "post one 201" \
    201
  test_case \
    "/orders" \
    "GET" \
    '' \
    "all orders 200" \
    200
}

function main() {
  test_auth
  get_token
  test_catalog
  test_cart
  test_orders
}

main
