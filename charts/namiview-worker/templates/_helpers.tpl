{{- define "namiview-worker.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "namiview-worker.fullname" -}}
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

{{- define "namiview-worker.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "namiview-worker.labels" -}}
helm.sh/chart: {{ include "namiview-worker.chart" . }}
{{ include "namiview-worker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "namiview-worker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "namiview-worker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "namiview-worker.connectionSecretName" -}}
{{ include "namiview-worker.fullname" . }}-connection-secret
{{- end }}

{{- define "namiview-worker.dockercfgSecretName" -}}
{{ include "namiview-worker.fullname" . }}-dockercfg
{{- end }}

{{/*
Atlas SRV connection string. Credentials interpolate at runtime via
Kubernetes env-var $(VAR) substitution — MONGO_USER/PASSWORD/DB must be
defined earlier in the env list for the substitution to work.
*/}}
{{- define "namiview-worker.mongoUri" -}}
mongodb+srv://$(MONGO_USER):$(MONGO_PASSWORD)@{{ .Values.app.mongo.host }}/$(MONGO_DB)?retryWrites=true&w=majority&appName={{ .Values.app.mongo.appName | default "namiview" }}
{{- end }}
