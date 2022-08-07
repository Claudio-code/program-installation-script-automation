#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

println_sucsess () {
  local message="$1"
  echo -e "${GREEN}[INFO]${NC} - ${message}"
}

println_error () {
  local message="$1"
  echo -e "${GREEN}[ERROR]${NC} - ${message}"
}

checking_internet_connection () {
  if ! ping -c 1 8.8.8.8 -q &> /dev/null ; then
    println_error "Your pc has no internet connection."
    exit 1
  fi

  println_sucsess "Your pc is connected to the internet."
}
