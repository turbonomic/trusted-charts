#
helm repo up

helm upgrade nginx-ingress nginx-ingress --namespace nginx-ingress \
  --set tcp.22="gitlab/gitlab-ce-gitlab-ce:22" -i
