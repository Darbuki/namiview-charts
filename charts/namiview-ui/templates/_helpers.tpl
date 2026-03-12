{{/*
Expand the name of the chart.
*/}}
{{- define "namiview-ui.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
If fullnameOverride is set, use it. Otherwise: release-chart (truncated).
*/}}
{{- define "namiview-ui.fullname" -}}
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
{{- define "namiview-ui.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "namiview-ui.labels" -}}
helm.sh/chart: {{ include "namiview-ui.chart" . }}
{{ include "namiview-ui.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels — keeps the existing `app: namiview-ui-app` label
for compatibility with the existing Service selector.
*/}}
{{- define "namiview-ui.selectorLabels" -}}
app.kubernetes.io/name: {{ include "namiview-ui.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Secret names — derived from fullname so prod and dev don't collide
when deployed to different namespaces.
*/}}
{{- define "namiview-ui.googleCredsSecretName" -}}
{{ include "namiview-ui.fullname" . }}-google-creds
{{- end }}

{{- define "namiview-ui.dockercfgSecretName" -}}
{{ include "namiview-ui.fullname" . }}-dockercfg
{{- end }}

