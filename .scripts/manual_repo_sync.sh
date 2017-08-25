#!/bin/bash
set -e

# the repo path to this repository
REPO_URL=trusted-charts.stackpoint.io

function gen_packages() {
  echo "Packaging charts from source code"
  mkdir -p temp
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
      helm package $d
      mv *.tgz temp/
    fi
  done

}

function index() {
  echo "Fetch charts and index.yaml"
  gsutil rsync gs://${REPO_URL} ./temp/

  echo "Indexing repository"
  if [ -f index.yaml ]; then
    helm repo index --url http://${REPO_URL} --merge index.yaml ./temp
  else
    helm repo index --url http://${REPO_URL} ./temp
  fi
  ## add index.html
  cp -f .web/index.html ./temp
}

function upload() {
  echo "Upload charts to GCS bucket"
  gsutil rsync ./temp/ gs://${REPO_URL}
}

# generate helm chart packages
gen_packages

# create index
index

# upload to GCS bucket
upload
