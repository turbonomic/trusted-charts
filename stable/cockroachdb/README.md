# CockroachDB Helm Chart

**It is based on Helm community chart [cockroachdb](https://github.com/kubernetes/charts/tree/master/stable/cockroachdb)**

## Prerequisites Details
* Kubernetes 1.5 (for StatefulSet support)
* PV support on the underlying infrastructure

## StatefulSet Details
* http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/

## StatefulSet Caveats
* http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets/#limitations

## Chart Details
This chart will do the following:

* Set up a dynamically scalable CockroachDB cluster using a Kubernetes StatefulSet

## Installing the Chart

To install the chart with the release name `cockroachdb`:

```shell
helm install tc/cockroachdb --name cockroachdb --namespace=cockroach
```

## Configuration

The following tables lists the configurable parameters of the CockroachDB chart and their default values.

| Parameter               | Description                        | Default                                                    |
| ----------------------- | ---------------------------------- | ---------------------------------------------------------- |
| `Name`                  | Chart name                         | `cockroachdb`                                              |
| `Image`                 | Container image name               | `cockroachdb/cockroach`                                    |
| `ImageTag`              | Container image tag                | `v1.0`                                                     |
| `ImagePullPolicy`       | Container pull policy              | `Always`                                                   |
| `Replicas`              | k8s statefulset replicas           | `3`                                                        |
| `MinAvailable`          | k8s PodDisruptionBudget parameter  | `67%`                                                      |
| `Component`             | k8s selector key                   | `cockroachdb`                                              |
| `GrpcPort`              | CockroachDB primary serving port   | `26257`                                                    |
| `HttpPort`              | CockroachDB HTTP port              | `8080`                                                     |
| `Cpu`                   | Container requested cpu            | `100m`                                                     |
| `Memory`                | Container requested memory         | `512Mi`                                                    |
| `Storage`               | Persistent volume size             | `1Gi`                                                      |
| `StorageClass`          | Persistent volume class            | `anything`                                                 |
| `ClusterDomain`         | Cluster's default DNS domain       | `cluster.local`                                            |
| `NetworkPolicy.Enabled` | Enable NetworkPolicy               | `false`                                                    |
| `NetworkPolicy.AllowExternal` | Don't require client label for connections | `true`                                       |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```shell
helm install tc/cockroachdb --name cockroachdb --namespace=cockroach -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

# Deep dive

## Connecting to the CockroachDB cluster

Once you've created the cluster, you can start talking to it it by connecting
to its "public" service. CockroachDB is PostgreSQL wire protocol compatible so
there's a [wide variety of supported
clients](https://www.cockroachlabs.com/docs/install-client-drivers.html). For
the sake of example, we'll open up a SQL shell using CockroachDB's built-in
shell and play around with it a bit, like this (likely needing to replace
"cockroachdb-cockroachdb-public" with the name of the "-public" service that
was created with your installed chart):

```console
$ kubectl run -it --rm cockroach-client \
    --image=cockroachdb/cockroach \
    --restart=Never \
    --command -- ./cockroach sql --insecure --host cockroachdb-cockroachdb-public
Waiting for pod default/cockroach-client to be running, status is Pending,
pod ready: false
If you don't see a command prompt, try pressing enter.
root@cockroachdb-cockroachdb-public:26257> SHOW DATABASES;
+--------------------+
|      Database      |
+--------------------+
| information_schema |
| pg_catalog         |
| system             |
+--------------------+
(3 rows)
root@cockroachdb-cockroachdb-public:26257> CREATE DATABASE bank;
CREATE DATABASE
root@cockroachdb-cockroachdb-public:26257> CREATE TABLE bank.accounts (id INT
PRIMARY KEY, balance DECIMAL);
CREATE TABLE
root@cockroachdb-cockroachdb-public:26257> INSERT INTO bank.accounts VALUES
(1234, 10000.50);
INSERT 1
root@cockroachdb-cockroachdb-public:26257> SELECT * FROM bank.accounts;
+------+---------+
|  id  | balance |
+------+---------+
| 1234 | 10000.5 |
+------+---------+
(1 row)
root@cockroachdb-cockroachdb-public:26257> \q
Waiting for pod default/cockroach-client to terminate, status is Running
pod "cockroach-client" deleted
```

## Cluster health

Because our pod spec includes regular health checks of the CockroachDB processes,
simply running `kubectl get pods` and looking at the `STATUS` column is sufficient
to determine the health of each instance in the cluster.

If you want more detailed information about the cluster, the best place to look
is the admin UI.

## Accessing the admin UI

If you want to see information about how the cluster is doing, you can try
pulling up the CockroachDB admin UI by port-forwarding from your local machine
to one of the pods (replacing "release-cockroachdb-0" with one of your pods' names):

```shell
kubectl port-forward release-cockroachdb-0 8080
```

Once you’ve done that, you should be able to access the admin UI by visiting
http://localhost:8080/ in your web browser.

## Failover

If any CockroachDB member fails it gets restarted or recreated automatically by
the Kubernetes infrastructure, and will rejoin the cluster automatically when
it comes back up. You can test this scenario by killing any of the pods:

```shell
kubectl delete pod cockroachdb-cockroachdb-1
```

```shell
$ kubectl get pods -l "component=cockroachdb-cockroachdb"
NAME                      READY     STATUS        RESTARTS   AGE
cockroachdb-cockroachdb-0  1/1       Running       0          5m
cockroachdb-cockroachdb-2  1/1       Running       0          5m
```

After a while:

```console
$ kubectl get pods -l "component=cockroachdb-cockroachdb"
NAME                      READY     STATUS        RESTARTS   AGE
cockroachdb-cockroachdb-0  1/1       Running       0          5m
cockroachdb-cockroachdb-1  1/1       Running       0          20s
cockroachdb-cockroachdb-2  1/1       Running       0          5m
```

You can check state of re-joining from the new pod's logs:

```console
$ kubectl logs cockroachdb-cockroachdb-1
[...]
I161028 19:32:09.754026 1 server/node.go:586  [n1] node connected via gossip and
verified as part of cluster {"35ecbc27-3f67-4e7d-9b8f-27c31aae17d6"}
[...]
cockroachdb-0.cockroachdb-cockroachdb.default.svc.cluster.local:26257
build:      beta-20161027-55-gd2d3c7f @ 2016/10/28 19:27:25 (go1.7.3)
admin:      http://0.0.0.0:8080
sql:
postgresql://root@cockroachdb-cockroachdb-1.cockroachdb-cockroachdb.default.svc.cluster.local:26257?sslmode=disable
logs:       cockroach-data/logs
store[0]:   path=cockroach-data
status:     restarted pre-existing node
clusterID:  {35ecbc27-3f67-4e7d-9b8f-27c31aae17d6}
nodeID:     2
[...]
```

## NetworkPolicy

To enable network policy for CockroachDB,
install [a networking plugin that implements the Kubernetes
NetworkPolicy spec](https://kubernetes.io/docs/tasks/administer-cluster/declare-network-policy#before-you-begin),
and set `NetworkPolicy.Enabled` to `true`.

For Kubernetes v1.5 & v1.6, you must also turn on NetworkPolicy by setting
the DefaultDeny namespace annotation. Note: this will enforce policy for _all_ pods in the namespace:

    kubectl annotate namespace default "net.beta.kubernetes.io/network-policy={\"ingress\":{\"isolation\":\"DefaultDeny\"}}"

For more precise policy, set `networkPolicy.allowExternal=false`. This will
only allow pods with the generated client label to connect to CockroachDB.
This label will be displayed in the output of a successful install.

## Scaling

Scaling should typically be managed via the `helm upgrade` command, but StatefulSets
don't yet work with `helm upgrade`. In the meantime until `helm upgrade` works,
if you want to change the number of replicas, you can use the `kubectl scale`
as shown below:

```shell
kubectl scale statefulset cockroachdb-cockroachdb --replicas=4
```
