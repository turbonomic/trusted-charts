#
helm repo up

helm upgrade kube-lego kube-lego --namespace kube-lego \
  --set config.LEGO_EMAIL="vendors@stackpointcloud.com" \
  --set config.LEGO_URL="https://acme-v01.api.letsencrypt.org/directory" \
  -i
