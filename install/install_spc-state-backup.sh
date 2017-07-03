# install for the first time
# AWS S3
helm upgrade --install spc-kube-backup spc/spc-state-backup --namespace stackpoint-system \
    --set schedule="*/50 * * * *",aws.enabled="true" \
    --set aws.accessKeyId="UNF37N93MG374B27",aws.secretAccessKey="AvgjbYndf9TMF8Y3F3J993TMTJ2309T" \
    --set aws.bucket="my-kube-state-backup-bucket",aws.region="eu-west-2" \
    --set jobCleanup.enabled="true" # set it only for k8s v1.5

# GCS
helm upgrade --install spc-kube-backup spc/spc-state-backup --namespace stackpoint-system \
    --set schedule="*/50 * * * *",gcs.enabled="true",gcs.projectId="project-123" \
    --set gcs.serviceAccountKey="$(cat /path/to/service-account.json | base64 -w 0)" \
    --set gcs.bucket="my-kube-state-backup",gcs.region="europe-west1" \
    --set jobCleanup.enabled="true" # set it only for k8s v1.5

### Azure
helm upgrade --install spc-kube-backup spc/spc-state-backup --namespace stackpoint-system \
    --set schedule="*/50 * * * *",azure.enabled="true",azure.storageAccount="azure_storage_account" \
    --set azure.storageAccessKey="AFSDJJDUEIEOOEOEOOEOEO" \
    --set azure.storageContainer="my-kube-state-backup-container" \
    --set jobCleanup.enabled="true" # set it only for k8s v1.5

# run upgrades e.g. for schedule or docker image change
helm upgrade spc-kube-backup spc/spc-state-backup --reuse-values --set schedule="*/30 * * * *"
helm upgrade spc-kube-backup spc/spc-state-backup --reuse-values --set imageTag="0.1.11"
