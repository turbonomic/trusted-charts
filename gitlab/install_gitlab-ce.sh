#
helm repo up

helm upgrade gitlab-ce gitlab-ce --namespace gitlab \
  --set externalHostname="rimusz.xyz",runnerRegistrationToken="49uf3mzs1qdz5vgo" \
  --set gitlabRootPassword="pass1234",runners.namespace="gitlab" \
  -i
