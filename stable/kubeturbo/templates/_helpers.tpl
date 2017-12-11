{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kubeturbo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "kubeturbo.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "vmturboconfig.contents" -}}
{
	"communicationConfig": {
		"serverMeta": {
			"version": "{{ .Values.vmturboconfig.turbonomic_server_api_version }}",
			"turboServer": "{{ .Values.vmturboconfig.turbonomic_url }}"
		},
		"restAPIConfig": {
			"opsManagerUserName": "{{ .Values.vmturboconfig.turbonomic_user }}",
			"opsManagerPassword": "{{ .Values.vmturboconfig.turbonomic_password }}"
		}
	},
	"targetConfig": {
		"probeCategory":"CloudNative",
		"targetType":"Kubernetes",
		"address":"{{ .Values.vmturboconfig.target_address }}"
	}
}
{{- end -}}
