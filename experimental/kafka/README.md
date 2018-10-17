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
cluster in its `requirement.yaml` by default. The chart can be customized using the
following configurable parameters:

| Parameter                                      | Description                                                                                                                                                              | Default                                                            |
|------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------|
| `image`                                        | Kafka Container image name                                                                                                                                               | `confluentinc/cp-kafka`                                            |
| `imageTag`                                     | Kafka Container image tag                                                                                                                                                | `4.1.2-2`                                                            |
| `imagePullPolicy`                              | Kafka Container pull policy                                                                                                                                              | `IfNotPresent`                                                     |
| `replicas`                                     | Kafka Brokers                                                                                                                                                            | `3`                                                                |
| `component`                                    | Kafka k8s selector key                                                                                                                                                   | `kafka`                                                            |
| `resources`                                    | Kafka resource requests and limits                                                                                                                                       | `{}`                                                               |
| `kafkaHeapOptions`                             | Kafka broker JVM heap options                                                                                                                                            | `-Xmx1G-Xms1G`                                                     |
| `logSubPath`                                   | Subpath under `persistence.mountPath` where kafka logs will be placed.                                                                                                   | `logs`                                                             |
| `schedulerName`                                | Name of Kubernetes scheduler (other than the default)                                                                                                                    | `nil`                                                              |
| `affinity`                                     | Defines affinities and anti-affinities for pods as defined in: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity preferences | `{}`                                                               |
| `tolerations`                                  | List of node tolerations for the pods. https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/                                                           | `[]`                                                               |
| `headless.annotations`                                  | List of annotations for the headless service. https://kubernetes.io/docs/concepts/services-networking/service/#headless-services                                                            | `[]`                                                               |
| `headless.targetPort`                                  | Target port to be used for the headless service. This is not a required value.                                                            | `nil`                                                               |
| `headless.port`                                  | Port to be used for the headless service. https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/                                                           | `9092`                                                               |
| `external.enabled`                             | If True, exposes Kafka brokers via NodePort (PLAINTEXT by default)                                                                                                       | `false`                                                            |
| `external.dns.useInternal`                     | If True, add Annotation for internal DNS service                                                                                                                           | `false`                                                          |
| `external.dns.useExternal`                     | If True, add Annotation for external DNS service                                                                                                                           | `true`                                                           |
| `external.servicePort`                         | TCP port configured at external services (one per pod) to relay from NodePort to the external listener port.                                                             | '19092'                                                            |
| `external.firstListenerPort`                   | TCP port which is added pod index number to arrive at the port used for NodePort and external listener port.                                                             | '31090'                                                            |
| `external.domain`                              | Domain in which to advertise Kafka external listeners.                                                                                                                   | `cluster.local`                                                    |
| `external.init`                                | External init container settings.                                                                                                                                        | (see `values.yaml`)                                                |
| `external.type`                                | Service Type.                                                                                                                                                            | `NodePort`                                                         |
| `external.distinct`                            | Distinct DNS entries for each created A record.                                                                                                                          | `false`                                                            |
| `external.annotations`                         | Additional annotations for the external service.                                                                                                                         | `{}`                                                               |
| `podAnnotations`                               | Annotation to be added to Kafka pods                                                                                                                                     | `{}`                                                               |
| `rbac.enabled`                                 | Enable a service account and role for the init container to use in an RBAC enabled cluster                                                                               | `false`                                                            |
| `envOverrides`                                 | Add additional Environment Variables in the dictionary format                       | `{ zookeeper.sasl.enabled: "False" }`                              |
| `configurationOverrides`                       | `Kafka ` [configuration setting][brokerconfigs] overrides in the dictionary format                                                                                       | `{ offsets.topic.replication.factor: 3 }`                          |
| `secrets` | `{}` | Pass any secrets to the kafka pods. Each secret will be passed as an environment variable by default. The secret can also be mounted to a specific path if required. Environment variable names are generated as: `<secretName>_<secretKey>` (All upper case)|
| `additionalPorts`                              | Additional ports to expose on brokers.  Useful when the image exposes metrics (like prometheus, etc.) through a javaagent instead of a sidecar                           | `{}`                                                               |
| `readinessProbe.initialDelaySeconds`           | Number of seconds before probe is initiated.                                                                                                                             | `30`                                                               |
| `readinessProbe.periodSeconds`                 | How often (in seconds) to perform the probe.                                                                                                                             | `10`                                                               |
| `readinessProbe.timeoutSeconds`                | Number of seconds after which the probe times out.                                                                                                                       | `5`                                                                |
| `readinessProbe.successThreshold`              | Minimum consecutive successes for the probe to be considered successful after having failed.                                                                             | `1`                                                                |
| `readinessProbe.failureThreshold`              | After the probe fails this many times, pod will be marked Unready.                                                                                                       | `3`                                                                |
| `terminationGracePeriodSeconds`                | Wait up to this many seconds for a broker to shut down gracefully, after which it is killed                                                                              | `60`                                                               |
| `updateStrategy`                               | StatefulSet update strategy to use.                                                                                                                                      | `{ type: "OnDelete" }`                                             |
| `podManagementPolicy`                          | Start and stop pods in Parallel or OrderedReady (one-by-one.)  Can not change after first release.                                                                       | `OrderedReady`                                                     |
| `persistence.enabled`                          | Use a PVC to persist data                                                                                                                                                | `true`                                                             |
| `persistence.size`                             | Size of data volume                                                                                                                                                      | `1Gi`                                                              |
| `persistence.mountPath`                        | Mount path of data volume                                                                                                                                                | `/opt/kafka/data`                                                  |
| `persistence.storageClass`                     | Storage class of backing PVC                                                                                                                                             | `nil`                                                              |
| `jmx.configMap.enabled`                        | Enable the default ConfigMap for JMX                                                                                                                                     | `true`                                                             |
| `jmx.configMap.overrideConfig`                 | Allows config file to be generated by passing values to ConfigMap                                                                                                        | `{}`                                                               |
| `jmx.configMap.overrideName`                   | Allows setting the name of the ConfigMap to be used                                                                                                                      | `""`                                                               |
| `jmx.port`                                     | The jmx port which JMX style metrics are exposed (note: these are not scrapeable by Prometheus)                                                                          | `5555`                                                             |
| `jmx.whitelistObjectNames`                     | Allows setting which JMX objects you want to expose to via JMX stats to JMX Exporter                                                                                     | (see `values.yaml`)                                                |
| `prometheus.jmx.resources`                     | Allows setting resource limits for jmx sidecar container                                                                                                                 | `{}`                                                               |
| `prometheus.jmx.enabled`                       | Whether or not to expose JMX metrics to Prometheus                                                                                                                       | `false`                                                            |
| `prometheus.jmx.image`                         | JMX Exporter container image                                                                                                                                             | `solsson/kafka-prometheus-jmx-exporter@sha256`                     |
| `prometheus.jmx.imageTag`                      | JMX Exporter container image tag                                                                                                                                         | `a23062396cd5af1acdf76512632c20ea6be76885dfc20cd9ff40fb23846557e8` |
| `prometheus.jmx.interval`                      | Interval that Prometheus scrapes JMX metrics when using Prometheus Operator                                                                                              | `10s`                                                              |
| `prometheus.jmx.scrapeTimeout`                 | Timeout that Prometheus scrapes JMX metrics when using Prometheus Operator                                                                                              | `10s`                                                              |
| `prometheus.jmx.port`                          | JMX Exporter Port which exposes metrics in Prometheus format for scraping                                                                                                | `5556`                                                             |
| `prometheus.kafka.enabled`                     | Whether or not to create a separate Kafka exporter                                                                                                                       | `false`                                                            |
| `prometheus.kafka.image`                       | Kafka Exporter container image                                                                                                                                           | `danielqsj/kafka-exporter`                                         |
| `prometheus.kafka.imageTag`                    | Kafka Exporter container image tag                                                                                                                                       | `v1.2.0`                                                           |
| `prometheus.kafka.interval`                    | Interval that Prometheus scrapes Kafka metrics when using Prometheus Operator                                                                                            | `10s`                                                              |
| `prometheus.kafka.scrapeTimeout`               | Timeout that Prometheus scrapes Kafka metrics when using Prometheus Operator                                                                                            | `10s`                                                              |
| `prometheus.kafka.port`                        | Kafka Exporter Port which exposes metrics in Prometheus format for scraping                                                                                              | `9308`                                                             |
| `prometheus.kafka.resources`                   | Allows setting resource limits for kafka-exporter pod                                                                                                                    | `{}`                                                               |
| `prometheus.operator.enabled`                  | True if using the Prometheus Operator, False if not                                                                                                                      | `false`                                                            |
| `prometheus.operator.serviceMonitor.namespace` | Namespace which Prometheus is running in.  Default to kube-prometheus install.                                                                                           | `monitoring`                                                       |
| `prometheus.operator.serviceMonitor.selector`  | Default to kube-prometheus install (CoreOS recommended), but should be set according to Prometheus install                                                               | `{ prometheus: kube-prometheus }`                                  |
| `topics`                                       | List of topics to create & configure. Can specify name, partitions, replicationFactor, reassignPartitions, config. See values.yaml                                       | `[]` (Empty list)                                                  |
| `zookeeper.enabled`                            | If True, installs Zookeeper Chart                                                                                                                                        | `true`                                                             |
| `zookeeper.resources`                          | Zookeeper resource requests and limits                                                                                                                                   | `{}`                                                               |
| `zookeeper.env`                                | Environmental variables provided to Zookeeper Zookeeper                                                                                                                  | `{ZK_HEAP_SIZE: "1G"}`                                             |
| `zookeeper.storage`                            | Zookeeper Persistent volume size                                                                                                                                         | `2Gi`                                                              |
| `zookeeper.image.PullPolicy`                   | Zookeeper Container pull policy                                                                                                                                          | `IfNotPresent`                                                     |
| `zookeeper.url`                                | URL of Zookeeper Cluster (unneeded if installing Zookeeper Chart)                                                                                                        | `""`                                                               |
| `zookeeper.port`                               | Port of Zookeeper Cluster                                                                                                                                                | `2181`                                                             |
| `zookeeper.affinity`                           | Defines affinities and anti-affinities for pods as defined

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
