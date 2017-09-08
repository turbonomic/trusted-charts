#!/bin/sh
set -e

# setup helm
echo "Installing curl"
apt update
apt install curl -y
#
echo "Installing helm"
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
helm init -c
helm repo add incubator	https://kubernetes-charts-incubator.storage.googleapis.com
helm repo update

# Package charts
echo "Packaging charts from source code"
mkdir -p temp
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
