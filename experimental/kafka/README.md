# Apache Kafka Helm Chart

**It is based on Helm community chart [kafka](https://github.com/kubernetes/charts/tree/master/incubator/kafka)**

**Note:** Please have at least four worker nodes to have Kafka working for you.

## Prerequisites Details
* Kubernetes 1.6+ with Beta APIs enabled.
* PV support on the underlying infrastructure.

## StatefulSet Details

* https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/

## StatefulSet Caveats

* https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#limitations

## Chart Details

This chart will do the following:

* Implement a dynamically scalable kafka cluster using Kubernetes StatefulSets

* Implement a dynamically scalable zookeeper cluster as another Kubernetes StatefulSet required for the Kafka cluster above

### Installing the Chart

To install the chart with the release name `my-kafka` and in the namespace `kafka`
namespace:

```bash
$ helm install tc/kafka --name my-kafka --namespace=kafka --set global.namespace=kafka
```

This chart includes a ZooKeeper chart as a dependency to the Kafka
cluster in its `requirement.yaml`. The chart can be customized using the
following configurable parameters:

| Parameter               | Description                        | Default                                                    |
| ----------------------- | ---------------------------------- | ---------------------------------------------------------- |
| `Image`                 | Kafka Container image name         | `solsson/kafka`                                            |
| `ImageTag`              | Kafka Container image tag          | `0.11.0.0`                                                 |
| `ImagePullPolicy`       | Kafka Container pull policy        | `Always`                                                   |
| `Replicas`              | Kafka Brokers                      | `3`                                                        |
| `Component`             | Kafka k8s selector key             | `kafka`                                                    |
| `resources`             | Kafka resource requests and limits | `{}`                                                       |
| `DataDirectory`         | Kafka data directory               | `/opt/kafka/data`                                          |
| `Storage`               | Kafka Persistent volume size       | `1Gi`                                                      |

Specify parameters using `--set key=value[,key=value]` argument to `helm install`

Alternatively a YAML file that specifies the values for the parameters can be provided like this:

```bash
$ helm install tc/kafka --name my-kafka --namespace=kafka -f values.yaml
```

### Connecting to Kafka

You can connect to Kafka by running a simple pod in the K8s cluster like this with a configuration like this:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: testclient
  namespace: kafka
spec:
  containers:
  - name: kafka
    image: solsson/kafka:0.11.0.0
    command:
      - sh
      - -c
      - "exec tail -f /dev/null"
```

Once you have the testclient pod above running, you can list all kafka
topics with:

` kubectl -n kafka exec -ti testclient -- ./bin/kafka-topics.sh --zookeeper
my-kafka-zookeeper:2181 --list`

Where `my-kafka` is the name of your helm release.

## Known Limitations

* Topic creation is not automated
* Only supports storage options that have backends for persistent volume claims
* Kafka cluster is not accessible via an external endpoint
