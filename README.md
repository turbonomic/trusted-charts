# SPC QM solutions based on Helm Charts

## Install the Helm

First, Install the latest [Helm release](https://github.com/kubernetes/helm#install).

## Add Helm charts repository

###

You need to add this Chart repo to Helm:
```console
$ helm repo add spc https://stackpointcloud.github.io/spc-solutions/
$ helm repo up
```

###

Then you can install charts as simple as:

Let's install nginx-ingress chart:
```
$ helm install spc/nginx-ingress
```

###

For more detailed solution install check [install](install) folder.
