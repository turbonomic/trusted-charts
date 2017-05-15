#
helm repo up

helm upgrade gitlab-runner-docker gitlab-runner-docker --namespace gitlab \
  --set gitlabUrl=http://gitlab-ce-gitlab-ce:8005/,runnerRegistrationToken="49uf3mzs1qdz5vgo" \
  -i
