# Netapp Service Mesh Powered by Istio

Netapp Service Mesh is powered by Istio.  [Istio](https://istio.io/) is an open platform for providing a uniform way to integrate microservices, manage traffic flow across microservices, enforce policies and aggregate telemetry data.

Netapp has added functionality to enable multiple cloud connectivity seamlessly, using pristine upstream Istio installation
technology and docker containers.

## Prerequisites

- Kubernetes 1.11 or newer
- Helm 2.10.0 or newer

## Resources Required

This chart deploys Istio which can use between 6-8gb of ram in a loaded steady-state.

## Installing the Chart

1. If a service account has not already been installed for Tiller, install one:
    ```
    $ kubectl apply -f helm/helm-service-account.yaml
    ```

1. If Tiller has not already been installed in your cluster, Install Tiller on your cluster with the service account:
    ```
    $ helm init --service-account tiller
    ```

1. Install the Netapp Service Mesh chart:
    ```
    $ helm install helm/netapp-service-mesh --name netapp-service-mesh --namespace nks-system
    ```

## Configuration

The Helm chart ships with reasonable defaults.  There may be circumstances in which defaults require overrides.
To override Helm values, use `--set key=value` argument during the `helm install` command.  Multiple `--set`
operations may be used in the same Helm operation.

The exposed helm options are explained in the following table:

| Parameter | Description | Values | Default |
| --- | --- | --- | --- |
| `global.hub` | Specifies the HUB for Netapp Service Mesh containers | registry/namespace | `docker.io/sdake` |
| `global.tag` | Specifies the TAG for Netapp Service Mesh containers | valid image tag | `sdake` |
| `global.imagePullPolicy` | Specifies the image pull policy | valid image pull policy | `IfNotPresent` |


## Uninstalling the Chart

> Uninstalling this chart does not delete Istio's registered CRDs.  Istio by design expects
> CRDs to leak into the Kubernetes environment.  As CRDs contain all runtime configuration
> data in CutomResources the Istio designers feel it is better to explicitly delete this
> configuration rather then unexpectedly lose it.

To uninstall/delete the `netapp-service-mesh` release but continue to track the release:
    ```
    $ helm delete netapp-service-mesh
    ```

To uninstall/delete the `netapp-service-mesh` release completely and make its name free for later use:
    ```
    $ helm delete netapp-service-mesh --purge
    ```

> Warning: Deleting CRDs will delete any configuration that you have made to Istio.

To delete all CRDs, install the netapp-service-mesh-cleanup chart
