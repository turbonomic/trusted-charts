#!/bin/bash
set -e

# the repo path to this repository
REPO_PATH="https://stackpointcloud.github.io/spc-solutions/"

function gen_packages() {
  for d in stable/*
  do
      # Will generate a helm package per chart in a folder
      echo $d
      helm package $d
      mv *.tgz docs/
  done
}

function index() {
  helm repo index --url ${REPO_PATH} ./docs
}

# generate helm chart packages
gen_packages

# create index
index
