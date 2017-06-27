# Trusted  Helm Charts

## Install the Helm

Install the latest [Helm release](https://github.com/kubernetes/helm#install).

## Add Helm charts repository

###

You need to add this Chart repo to Helm:
```console
$ mkdir -p ${HOME}/.helm/repository/local/
$ helm repo index ${HOME}/.helm/repository/local/
$ helm repo add spc http://trusted-charts.stackpoint.io/
$ helm repo up
```
