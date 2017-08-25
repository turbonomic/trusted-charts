# Trusted Helm Charts Repository - Vendor maintained, Stackpoint.io certified

Use this repository to submit Trusted Helm Charts for Kubernetes [Helm](https://helm.sh).


## Install Helm

Get the latest [Helm release](https://github.com/kubernetes/helm#install).


## Install Charts

You need to add this Chart repo to Helm:
```console
$ helm repo add tc http://trusted-charts.stackpoint.io/
$ helm repo update
```
Now you can then run `helm search tc` to see the available charts.

**Note:** How to install charts follow install instructions in chart's _readme_.


## Contributing to Trusted Charts

Make a [pull request](https://help.github.com/articles/using-pull-requests) (PR).

Upon successful review, someone will give the PR a __LGTM__ (_looks good to me_) in the review thread.


## Docs

For more information on using Helm, refer to the Helm's [documentation](https://docs.helm.sh/using_helm/#quickstart-guide).
To get a quick introduction to Charts see this Chart's [documentation](https://docs.helm.sh/developing_charts/#charts).
