#
helm repo up

helm upgrade gitlab-runner gitlab-runner --namespace gitlab \
  --set gitlabUrl=http://gitlab-ce-gitlab-ce:8005/,runnerRegistrationToken="49uf3mzs1qdz5vgo" \
  --set runners.privileged="true" \
  -i
