# Kubeless

[Kubeless](http://kubeless.io) is a Kubernetes-native serverless framework. It is currently under active development.

Kubeless stands out as we use a **ThirdPartyResource** to be able to create functions as custom resources. We then run an in-cluster controller that watches these custom resources and launches _runtimes_ on-demand. These runtimes, dynamically inject the functions and make them available over HTTP or via a PubSub mechanism.

For PubSub we use [Kafka](https://kafka.apache.org). Currently we start Kafka and Zookeeper in a non-persistent setup. With `kubeless` you can create topics, and publish events that get consumed by the runtime and your even triggered functions.

## Introduction

This chart bootstraps a [Kubeless](http://kubeless.io) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.6+


## Installing the Chart

To install the chart with the release name `kubeless`:

```console
$ helm repo add spc http://trusted-charts.stackpoint.io/
$ helm repo up
$ helm install --name kubeless --namespace kubeless spc/kubeless
```

The command deploys Kubeless on the Kubernetes cluster in the default configuration.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `kubeless` deployment:

```console
$ helm delete kubeless
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
