#
helm repo up

helm install --namespace monitoring --name=promop \
   spc/prometheus-operator

helm install --namespace monitoring --name=pk8s \
   spc/prometheus

helm install --namespace=monitoring --name=dashboard \
   --set auth.allowAnonAccess=false \
   --set auth.adminUser=prometheus \
   --set auth.adminPassword=grafana \
   --set ingress.enabled=false \
  spc/grafana
