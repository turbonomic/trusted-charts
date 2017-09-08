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

# generate index
echo "Indexing repository"
if [ -f ./temp/index.yaml ]; then
  helm repo index --url http://${REPO_URL} --merge ./temp/index.yaml ./temp
else
  helm repo index --url http://${REPO_URL} ./temp
fi

## add index.html
cp -f .web/index.html ./temp
