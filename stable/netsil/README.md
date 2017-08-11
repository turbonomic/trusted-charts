# Netsil

[Netsil](https://netsil.com/) provides universal observability.

Netsil Application Operations Center (AOC) is a next-gen observability and analytics tool for modern cloud applications. The Netsil AOC helps SREs and DevOps improve the reliability and performance of API and microservices-driven production applications.

At the heart of the AOC is an auto-discovered service topology map. It visualizes service dependencies and operational metrics so practitioners can work collaboratively across teams.

## Introduction

This chart adds the Netsil AOC to all nodes in your cluster via a DaemonSet. It also depends on the [kube-state-metrics chart](https://github.com/kubernetes/charts/tree/master/stable/kube-state-metrics).

## Prerequisites

- Kubernetes 1.6+

## Installing the Chart

To install the chart with the release name `netsil`:

```console
$ helm upgrade --install netsil spc/netsil --namespace netsil
```

The command deploys _netsil_ on the Kubernetes cluster in the default configuration.

## Uninstalling the Chart

To uninstall/delete the _netsil_ deployment:

```console
$ helm delete --purge netsil
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
