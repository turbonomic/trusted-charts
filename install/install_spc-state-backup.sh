# install for the first time
# AWS S3
helm upgrade --install kube-backup spc/spc-state-backup --namespace stackpoint-system \
    --set schedule="*/50 * * * *",aws.enabled="true" \
    --set aws.accessKeyId="UNF37N93MG374B27",aws.secretAccessKey="AvgjbYndf9TMF8Y3F3J993TMTJ2309T" \
    --set aws.bucket="my-kube-state-backup-bucket",aws.region="eu-west-2" \
    --set jobCleanup.enabled="true" # set it only for k8s v1.5

# GCS
helm upgrade --install kube-backup spc/spc-state-backup --namespace stackpoint-system \
    --set schedule="*/50 * * * *",gcs.enabled="true",gcs.projectId="project-123" \
    --set gcs.serviceAccountKey="$(cat /path/to/service-account.json | base64 -w 0)" \
    --set gcs.bucket="my-kube-state-backup",gcs.region="eu" \
    --set jobCleanup.enabled="true" # set it only for k8s v1.5

# run upgrades e.g. for schedule or docker image change
helm upgrade kube-backup spc/spc-state-backup --reuse-values --set schedule="*/30 * * * *"
helm upgrade kube-backup spc/spc-state-backup --reuse-values --set imageTag="0.1.8"
