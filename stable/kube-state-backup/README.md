# Kubernetes state backup as a Cron Job

This chart will schedule [Kubernetes Cron Job](https://kubernetes.io/docs/user-guide/cron-jobs/) to backup Kubernetes state to cloud storage.

## TL;DR;

```bash
$ helm upgrade --install kube-backup kube-state-backup --namespace kube-backup \
    --set schedule="*/50 * * * *" \
    --set aws.accessKeyId="accessKeyId",aws.secretAccessKey="secretAccessKey" \
    --set aws.bucket="my-kube-state-backup",aws.region="eu-west-2"
```
