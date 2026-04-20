{{/*
Expand the name of the chart.
*/}}
{{- define "namiview-triage.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Fully qualified app name.
*/}}
{{- define "namiview-triage.fullname" -}}
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
{{- define "namiview-triage.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "namiview-triage.labels" -}}
helm.sh/chart: {{ include "namiview-triage.chart" . }}
{{ include "namiview-triage.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "namiview-triage.selectorLabels" -}}
app.kubernetes.io/name: {{ include "namiview-triage.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Service account name
*/}}
{{- define "namiview-triage.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "namiview-triage.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Secret names — one per ExternalSecret so each is a first-class k8s object.
*/}}
{{- define "namiview-triage.anthropicSecretName" -}}
{{ include "namiview-triage.fullname" . }}-anthropic
{{- end }}

{{- define "namiview-triage.githubSecretName" -}}
{{ include "namiview-triage.fullname" . }}-github
{{- end }}
