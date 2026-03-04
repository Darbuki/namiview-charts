{{/*
Expand the name of the chart.
*/}}
{{- define "namiview.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
If fullnameOverride is set, use it. Otherwise: release-chart (truncated).
*/}}
{{- define "namiview.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Chart label
*/}}
{{- define "namiview.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "namiview.labels" -}}
helm.sh/chart: {{ include "namiview.chart" . }}
{{ include "namiview.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels — keeps the existing `app: namiview-app` label
for compatibility with the existing Service selector.
*/}}
{{- define "namiview.selectorLabels" -}}
app.kubernetes.io/name: {{ include "namiview.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: namiview-app
{{- end }}

{{/*
Secret names — derived from fullname so prod and dev don't collide
when deployed to different namespaces.
*/}}
{{- define "namiview.connectionSecretName" -}}
{{ include "namiview.fullname" . }}-connection-secret
{{- end }}

{{- define "namiview.googleCredsSecretName" -}}
{{ include "namiview.fullname" . }}-google-creds
{{- end }}

{{- define "namiview.dockercfgSecretName" -}}
{{ include "namiview.fullname" . }}-dockercfg
{{- end }}

{{/*
Build the MongoDB replica set connection string.
Credentials are injected at runtime via Kubernetes env var interpolation
using $(MONGO_USER), $(MONGO_PASSWORD), and $(MONGO_DB) — these must be
defined earlier in the env list.
*/}}
{{- define "namiview.mongoUri" -}}
mongodb://$(MONGO_USER):$(MONGO_PASSWORD)@{{ join "," .Values.app.mongo.hosts }}/$(MONGO_DB)?replicaSet={{ .Values.app.mongo.replicaSet }}&authSource={{ .Values.app.mongo.authSource }}
{{- end }}
