{{/*
Expand the name of the chart.
*/}}
{{- define "namiview-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
If fullnameOverride is set, use it. Otherwise: release-chart (truncated).
*/}}
{{- define "namiview-api.fullname" -}}
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
{{- define "namiview-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "namiview-api.labels" -}}
helm.sh/chart: {{ include "namiview-api.chart" . }}
{{ include "namiview-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "namiview-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "namiview-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Secret names — derived from fullname so prod and dev don't collide
when deployed to different namespaces.
*/}}
{{- define "namiview-api.connectionSecretName" -}}
{{ include "namiview-api.fullname" . }}-connection-secret
{{- end }}

{{- define "namiview-api.dockercfgSecretName" -}}
{{ include "namiview-api.fullname" . }}-dockercfg
{{- end }}

{{- define "namiview-api.googleCredsSecretName" -}}
{{ include "namiview-api.fullname" . }}-google-creds
{{- end }}

{{- define "namiview-api.jwtSecretName" -}}
{{ include "namiview-api.fullname" . }}-jwt
{{- end }}

{{/*
Build the MongoDB replica set connection string.
Credentials are injected at runtime via Kubernetes env var interpolation
using $(MONGO_USER), $(MONGO_PASSWORD), and $(MONGO_DB) — these must be
defined earlier in the env list.
*/}}
{{- define "namiview-api.mongoUri" -}}
mongodb://$(MONGO_USER):$(MONGO_PASSWORD)@{{ join "," .Values.app.mongo.hosts }}/$(MONGO_DB)?replicaSet={{ .Values.app.mongo.replicaSet }}&authSource={{ .Values.app.mongo.authSource }}
{{- end }}
