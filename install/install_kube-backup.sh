# install for the first time
helm upgrade --install kube-backup spc/kube-state-backup --namespace stackpoint-system \
    --set schedule="*/50 * * * *" \
    --set aws.accessKeyId="UNF37N93MG374B27",aws.secretAccessKey="AvgjbYndf9TMF8Y3F3J993TMTJ2309T" \
    --set aws.bucket="my-kube-state-backup-bucket",aws.region="eu-west-2"

# run upgrades e.g. for schedule or docker image change
helm upgrade kube-backup spc/kube-state-backup --reuse-values --set schedule="*/7 * * * *"
helm upgrade kube-backup spc/kube-state-backup --reuse-values --set imageTag="0.1.3"
