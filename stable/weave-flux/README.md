# Weave Flux

> ***NOTE: This chart is for Kubernetes version 1.6 and later.***

Weave Flux is a add-on to Kubernetes which provides Continuous Delivery.

This package contains the agents which connect your cluster to Weave Cloud.

_To learn more and sign up please visit [Weaveworks website](https://weave.works)._

You will need a service token which you can get from [cloud.weave.works](https://cloud.weave.works/).

## Installing the Chart

To install the chart:

```console
$ helm install --name weave-flux --namespace kube-system --set cloud.serviceToken=<YOUR_WEAVE_CLOUD_SERVICE_TOKEN> spc/weave-flux
```

To view the pods installed:
```console
$ kubectl get pods -n kube-system -l weave-flux-component
```

## Uninstalling the Chart

To uninstall/delete the `weave-flux` chart:

```console
$ helm delete weave-flux
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

