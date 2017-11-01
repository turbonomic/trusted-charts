#!/bin/bash
set -e

# the repo path to this repository
REPO_URL=trusted-charts.stackpoint.io

function gen_packages() {
  echo "Packaging charts from source code"
  mkdir -p temp
  rm temp/*
  # generating charts from stable & experimental folders
  for d in stable/* experimental/*
  do
   if [[ -d $d ]]
   then
      # Will generate a helm package per chart in a folder
      echo $d
      helm dep up $d
      helm package $d
      mv *.tgz temp/
    fi
  done
}

function index() {
  echo "Fetching index.yaml"
  gsutil cp gs://${REPO_URL}/index.yaml ./temp/

  echo "Indexing repository"
  if [ -f ./temp/index.yaml ]; then
    helm repo index --url http://${REPO_URL} --merge ./temp/index.yaml ./temp
  else
    helm repo index --url http://${REPO_URL} ./temp
  fi
  ## add index.html
  cp -f .web/index.html ./temp
}

function upload() {
  echo "Upload charts to GCS bucket"
  gsutil rsync -x "test|staging" ./temp/ gs://${REPO_URL}
}

# generate helm chart packages
gen_packages

# create index
index

# upload to GCS bucket
upload
