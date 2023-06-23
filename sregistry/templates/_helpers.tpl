{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "sregistry.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sregistry.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sregistry.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "sregistry.labels" -}}
helm.sh/chart: {{ include "sregistry.chart" . }}
{{ include "sregistry.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "sregistry.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sregistry.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Switch between http and https based on TLS availability
*/}}
{{- define "http.prefix" -}}
{{- if .Values.images.nginx.tlsSecretName -}}https{{- else -}}http{{- end -}}
{{- end -}}

{{/*
OAUTH2 prefix added for select plugins
*/}}
{{- define "oauth.prefix" -}}
{{ if or  (eq . "google") (eq . "bitbucket") }}_OAUTH2{{ end }}
{{- end -}}

{{/*
Environment to propagate within sregistry containers
*/}}
{{- define "sregistry.env" -}}
env:
- name: MINIO_ACCESS_KEY
  value: {{ .Values.minio.auth.rootUser | quote }}
- name: MINIO_SECRET_KEY
  value: {{ .Values.minio.auth.rootPassword | quote }}
- name: REDIS_URL
  value: "redis://{{ .Values.redis.hostname }}/0"
{{ toYaml .Values.minio.extraEnv }}
{{- end -}}

{{/*
Volume claim templates when persistence is enabled
*/}}
{{- define "sregistry.claimTemplate" -}}
{{- if .enabled -}}
volumeClaimTemplates:
- metadata:
    name: static-vol
  spec:
    accessModes: [ {{ .accessMode | quote }} ]
    {{- if .storageClass }}
    {{- if (eq "-" .storageClass) }}
    storageClassName: ""
    {{- else }}
    storageClassName: {{ .storageClass | quote }}
    {{- end }}
    {{- end }}
    resources:
      requests:
        storage: 5Gi
- metadata:
    name: images-vol
  spec:
    accessModes: [ {{ .accessMode | quote }} ]
    {{- if .storageClass }}
    {{- if (eq "-" .storageClass) }}
    storageClassName: ""
    {{- else }}
    storageClassName: {{ .storageClass | quote }}
    {{- end }}
    {{- end }}
    resources:
      requests:
        storage: {{ .size }}
{{- end -}}
{{- end -}}

{{/*
Custom plugin volumes to be mounted from configMaps
*/}}
{{- define "sregistry.customVolumes" -}}
{{- if not .Values.persistence.enabled -}}
- name: static-vol
  emptyDir: {}
- name: images-vol
  emptyDir: {}
{{- end -}}
{{- range .Values.auth.customPlugins -}}
- name: {{ .name }}-vol
  configMap:
    name: {{ .configMap }}
{{- end -}}
{{- end -}}

{{/*
Shared volume mounts
*/}}
{{- define "sregistry.mounts" -}}
volumeMounts:
- mountPath: /var/www/static
  name: static-vol
- mountPath: /var/www/images
  name: images-vol
- mountPath: /code/shub/settings/secrets.py
  subPath: secrets.py
  name: shub-vol
- mountPath: /code/shub/settings/config.py
  subPath: config.py
  name: shub-vol
{{- range . }}
- mountPath: /code/shub/plugins/{{ .name }}
  name: {{ .name }}-vol
{{- end -}}
{{- end -}}

{{/*
Liveness container probe parameters
*/}}
{{- define "sregistry.probes" -}}
initialDelaySeconds: {{ .initialDelaySeconds }}
periodSeconds: {{ .periodSeconds }}
timeoutSeconds: {{ .timeoutSeconds }}
successThreshold: {{ .successThreshold }}
failureThreshold: {{ .failureThreshold }}
{{- end -}}
