#
helm repo up

#
helm upgrade nginx-ingress spc/nginx-ingress --namespace nginx-ingress \
  --set tcp.22="gitlab/gitlab-ce-gitlab-ce:22" -i

#
helm upgrade kube-lego spc/kube-lego --namespace kube-lego \
  --set config.LEGO_EMAIL="vendors@stackpointcloud.com" \
  --set config.LEGO_URL="https://acme-v01.api.letsencrypt.org/directory" \
  -i

# replace 'instanceId' with a actual kube cluster name
# for production do not set 'env'
helm upgrade gitlab-ce spc/gitlab --namespace gitlab \
  --set instanceId="spcm0eiut2",env=".staging",runnerRegistrationToken="49uf3mzs1qdz5vgo" \
  --set gitlabRootPassword="pass1234",runners.namespace="gitlab" \
  -i

#
helm upgrade gitlab-runner spc/gitlab-runner --namespace gitlab \
  --set gitlabUrl=http://gitlab-ce-gitlab:8005/,runnerRegistrationToken="49uf3mzs1qdz5vgo" \
  --set runners.privileged="true" \
  -i
