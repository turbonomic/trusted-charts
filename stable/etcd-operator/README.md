# CoreOS etcd-operator

**It is based on Helm community chart [etcd-operator](https://github.com/kubernetes/charts/tree/master/stable/etcd-operator)**

[etcd-operator](https://coreos.com/blog/introducing-the-etcd-operator.html) simplifies etcd cluster
configuration and management.

## Introduction

This chart bootstraps an etcd-operator and allows the deployment of etcd-cluster(s).

## Official Documentation

Official project documentation found [here](https://github.com/coreos/etcd-operator)

## Prerequisites

- Kubernetes 1.7+
- __Suggested:__ PV provisioner support in the underlying infrastructure to support backups

## Installing the Chart

To install the chart with the release name `etcd-operator`:

```bash
$ helm install tc/etcd-operator --name etcd-operator
```
By default it will install etcd-operator with 3 member etcd cluster.

## Resize an etcd-cluster

Size up etcd-cluster to 5 members one:

```bash
$ helm upgrade --install etcd-operator tc/etcd-operator --set cluster.size="5"
```

Check the cluster:

```bash
$ kubectl get pods -l etcd_cluster=etcd-cluster
NAME                READY     STATUS    RESTARTS   AGE
etcd-cluster-0000   1/1       Running   0          7m
etcd-cluster-0001   1/1       Running   0          7m
etcd-cluster-0002   1/1       Running   0          6m
etcd-cluster-0003   1/1       Running   0          54s
etcd-cluster-0004   1/1       Running   0          41s
```

And you easily size it down:

```bash
$ helm upgrade --install etcd-operator tc/etcd-operator --set cluster.size="3"
```

## Uninstalling the Chart

To uninstall/delete the `etcd-operator` deployment:

```bash
$ helm delete etcd-operator
```

The command removes all the Kubernetes components EXCEPT the persistent volumes, StorageClass, CRD and EtcdCluster created by etcd-operator.


## Configuration

The following tables lists the configurable parameters of the etcd-operator chart and their default values.

| Parameter                                         | Description                                                          | Default                                        |
| ------------------------------------------------- | -------------------------------------------------------------------- | ---------------------------------------------- |
| `replicaCount`                                    | Number of etcd-operator replicas to create (only 1 is supported)     | `1`                                            |
| `image.repository`                                | etcd-operator container image                                        | `quay.io/coreos/etcd-operator`                 |
| `image.tag`                                       | etcd-operator container image tag                                    | `v0.6.0`                                       |
| `image.pullPolicy`                                | etcd-operator container image pull policy                            | `IfNoCRDesent`                                 |
| `resources.limits.cpu`                            | CPU limit per etcd-operator pod                                      | `100m`                                         |
| `resources.limits.memory`                         | Memory limit per etcd-operator pod                                   | `128Mi`                                        |
| `resources.requests.cpu`                          | CPU request per etcd-operator pod                                    | `100m`                                         |
| `resources.requests.memory`                       | Memory request per etcd-operator pod                                 | `128Mi`                                        |
| `nodeSelector`                                    | node labels for etcd-operator pod assignment                         | `{}`                                           |
| `cluster.enabled`                                 | Whether to enable provisioning of an etcd-cluster                    | `true`                                        |
| `cluster.name`                                    | etcd cluster name                                                    | `etcd-cluster`                                 |
| `cluster.version`                                 | etcd cluster version                                                 | `v3.1.8`                                       |
| `cluster.size`                                    | etcd cluster size                                                    | `3`                                            |
| `cluster.backup.enabled`                          | Whether to create PV for cluster backups                             | `false`                                        |
| `cluster.backup.provisioner`                      | Which PV provisioner to use `gce-pd/aws-ebs`                         |  |
| `cluster.backup.config.snapshotIntervalInSecond`  | etcd snapshot interval in seconds                                    | `30`                                           |
| `cluster.backup.config.maxSnapshot`               | maximum number of snapshots to keep                                  | `5`                                            |
| `cluster.backup.config.storageType`               | Type of storage to provision                                         | `PersistentVolume`                             |
| `cluster.backup.config.pv.volumeSizeInMB`         | size of backup PV                                                    | `2048MB`                                        |
| `cluster.restore.enabled`                         | Whether to restore from PV                                           | `false`                                        |
| `cluster.restore.config.storageType`              | Type of storage to restore from                                      | `PersistentVolume`                             |
| `cluster.restore.config.backupClusterName`        | Name of cluster to restore from                                      | `etcd-cluster`                                 |
| `cluster.pod.antiAffinity`                        | Whether etcd cluster pods should have an antiAffinity                | `false`                                        |
| `cluster.pod.resources.limits.cpu`                | CPU limit per etcd cluster pod                                       | `100m`                                         |
| `cluster.pod.resources.limits.memory`             | Memory limit per etcd cluster pod                                    | `128Mi`                                        |
| `cluster.pod.resources.requests.cpu`              | CPU request per etcd cluster pod                                     | `100m`                                         |
| `cluster.pod.resources.requests.memory`           | Memory request per etcd cluster pod                                  | `128Mi`                                        |
| `cluster.pod.nodeSelector`                        | node labels for etcd cluster pod assignment                          | `{}`                                           |
| `rbac.install`                                    | install required rbac service account, roles and rolebindings        | `false`                                         |
| `rbac.apiVersion`                                 | rbac api version `v1beta1`                                  | `v1beta1`                                      |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```bash
$ helm install --name etcd-operator --set image.tag=v0.6.0 tc/etcd-operator
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while
installing the chart. For example:

```bash
$ helm install --name etcd-operator --values values.yaml tc/etcd-operator
```

## RBAC
By default the chart will not install the recommended RBAC roles and rolebindings.

To determine if your cluster supports this running the following:

```console
$ kubectl api-versions | grep rbac
```

You also need to have the following parameter on the api server. See the following document for how to enable [RBAC](https://kubernetes.io/docs/admin/authorization/rbac/)

```
--authorization-mode=RBAC
```

If the output contains "beta" or both "alpha" and "beta" you can may install with enabling the creating of rbac resources (see below).

### Enable RBAC role/rolebinding creation

To enable the creation of RBAC resources (On clusters with RBAC). Do the following:

```console
$ helm install --name etcd-operator tc/etcd-operator --set rbac.install=true
```

### Changing RBAC manifest apiVersion

By default the RBAC resources are generated with the "v1beta1" apiVersion. To use "v1alpha1" do the following:

```console
$ helm install --name etcd-operator tc/etcd-operator --set rbac.install=true,rbac.apiVersion=v1beta1
```
