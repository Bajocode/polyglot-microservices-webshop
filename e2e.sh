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
    -d "${body}" \
    -w "\n%{http_code}\n%{time_total}" \
    -s
}

function log_request() {
  local method=$1 path=$2 code=$3 duration=$4 body=$5
  echo $body
  echo -e "\n${BLUE}${method} ${BASE_URL}${path} [${code}, ${duration}s]${NC}"
}

function assert_case() {
  local case_text=$1 expected=$2 actual=$3
  if [[ "${expected}" == "${actual}" ]]; then
    echo -e " ${GREEN}${case_text}${NC}"
  else
    echo -e " ${RED}${case_text}${NC}"
    echo "  - actual: ${actual}"
    echo "  - expected: ${expected}"
  fi
}

function test_auth() {
  local service_path="/auth"
  echo $service_path

  test_register "${service_path}"
}

function test_register() {
  local method="POST" path="${1}/register"
  local case_text req_body res_curl res_body res_code res_dur

  req_body='{"email": "w", "password": "w"}'
  res_curl=$(execute_request "${method}" "${path}" "${req_body}")
  IFS=$'\n' read -rd "" res_body res_code res_dur <<< "${res_curl}"
  log_request "${method}" "${path}" "${res_code}" "${res_dur}" "$res_body"
  assert_case "new email returns 201" "201" "${res_code}"

  sleep "${DELAY_SECONDS}"
}


function main() {
  test_auth
}

main
