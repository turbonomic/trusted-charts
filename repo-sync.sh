#!/bin/bash
set -e

# the repo path to this repository
REPO_URL="http://trusted-charts.stackpoint.io/"

function gen_packages() {
  echo "Packaging charts from source code"
  mkdir -p temp
  # generating charts from stable folder
  for d in stable/*
  do
   if [[ -d $d ]]
   then
      # Will generate a helm package per chart in a folder
      echo $d
      helm package $d
      mv *.tgz temp/
    fi
  done

  # generating charts from incubator folder
  for d in incubator/*
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
  echo "Fetch charts and index.yaml"
  aws s3 sync s3://trusted-charts.stackpoint.io ./temp/

  echo "Indexing repository"
  if [ -f index.yaml ]; then
    helm repo index --url ${REPO_URL} --merge index.yaml ./temp
  else
    helm repo index --url ${REPO_URL} ./temp
  fi
  ## add index.html
  cp -f .web/index.html ./temp
}

function upload() {
  echo "Upload charts to S3 bucket"
  aws s3 sync ./temp/ s3://trusted-charts.stackpoint.io
}

# generate helm chart packages
gen_packages

# create index
index

# upload to S3 bucket
upload
