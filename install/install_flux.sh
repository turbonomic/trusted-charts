#
helm repo up

# with a Weave cloud
helm upgrade flux spc/weave-flux --namespace weave \
  --set cloud.serviceToken=<YOUR_WEAVE_CLOUD_SERVICE_TOKEN> \
  -i

# with a custom docker image and to run as a standalone
helm upgrade flux spc/weave-flux --namespace weave \
  --set image.agentRepository="quay.io/stackpoint/fluxd" \
  --set image.serverRepository="quay.io/stackpoint/fluxsvc" \
  --set image.tag="0.1.0" \
  -i
