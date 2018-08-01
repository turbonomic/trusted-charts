# Istio

**It is based on Helm community chart [istio](https://github.com/istio/istio/)**

[Istio](https://istio.io/), Istio is an open platform that provides a uniform way to connect, manage, and secure microservices. Istio supports managing traffic flows between microservices, enforcing access policies, and aggregating telemetry data, all without requiring changes to the microservice code.

## TL;DR;

```console
$ helm repo add tc http://trusted-charts.stackpoint.io/
$ helm repo up
$ helm install --name istio --namespace istio-system tc/istio
```

## Introduction

This chart bootstraps a [Istio](https://istio.io/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.9+ if you would like to use the Initializer (auto-inject)
- istioctl

### istioctl installation steps

Run
```console
curl -L https://git.io/getLatestIstio | sh -
```
to download and extract the latest release automatically (on MacOS and Ubuntu), the `istioctl` client will be added to your PATH by the above shell command.

## RBAC
By default the chart is installed with RBAC roles and rolebindings.

## Installing the Chart

It is recommended that you install Istio into the istio-system namespace.

To install the chart with the release name `istio` into the namespace istio-system:

```console
$ helm install --name istio --namespace istio-system tc/istio
```

The command deploys Istio on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `istio` deployment:

```console
$ helm delete istio
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following tables lists the configurable parameters of the Istio chart and their default values.

> **Tip**: You can use the default [values.yaml](values.yaml)

Parameter | Description | Default
--------- | ----------- | -------
 |  |  |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install tc/istio --name istio --namespace istio-system -f values.yaml
```
