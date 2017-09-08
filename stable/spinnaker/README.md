# Spinnaker Chart

**It is based on Helm community chart [spinnaker](https://github.com/kubernetes/charts/tree/master/stable/spinnaker)**

**Note:** Spinnaker needs powerful VMs, please have at least four worker nodes with two CPU and 8GB RAM each.

[Spinnaker](http://spinnaker.io/) is an open source, multi-cloud continuous delivery platform.

## Chart Details
This chart will provision a fully functional and fully featured Spinnaker installation
that can deploy and manage applications in the cluster that it is deployed to.

Redis and Minio are used as the stores for Spinnaker state.

For more information on Spinnaker and its capabilities, see it's [documentation](http://www.spinnaker.io/docs).

## Installing the Chart

To install the chart with the release name `spinnaker`:

```bash
$ helm install tc/spinnaker --name spinnaker --namespace=spinnaker
```

Note that this chart pulls in many different Docker images so can take a while to fully install.

## Configuration

Configurable values are documented in the `values.yaml`.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install tc/spinnaker --name spinnaker --namespace=spinnaker \
  -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)
