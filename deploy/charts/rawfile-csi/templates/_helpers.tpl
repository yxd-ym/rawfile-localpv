{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "rawfile-csi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rawfile-csi.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "rawfile-csi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rawfile-csi.labels" -}}
helm.sh/chart: {{ include "rawfile-csi.chart" . }}
{{ include "rawfile-csi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rawfile-csi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rawfile-csi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "rawfile-csi.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rawfile-csi.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Some helpers to handle image global information
*/}}
{{- define "rawfile-csi.controller-image-tag" -}}
{{- $imageTag := .Values.image.tag | default .Chart.AppVersion }}
{{- printf "%s" $imageTag }}
{{- end }}

{{- define "rawfile-csi.controller-image-repository" -}}
{{- printf "%s" .Values.image.repository }}
{{- end }}

{{- define "rawfile-csi.controller-image" -}}
{{- $imageTag := .Values.controller.image.tag | default (.Values.image.tag | default .Chart.AppVersion) }}
{{- $imageRegistry := .Values.image.registry | default .Values.global.imageRegistry }}
{{- printf "%s/%s:%s" $imageRegistry (include "rawfile-csi.controller-image-repository" .) (include "rawfile-csi.controller-image-tag" .) }}
{{- end }}

{{- define "rawfile-csi.controller-pull-policy" -}}
{{- printf "%s" (.Values.image.pullPolicy | default .Values.global.imagePullPolicy) }}
{{- end }}

{{- define "rawfile-csi.controller-resources" -}}
{{- toYaml (.Values.controller.resources) }}
{{- end }}

{{- define "rawfile-csi.node-image-tag" -}}
{{- $imageTag := .Values.image.tag | default .Chart.AppVersion }}
{{- printf "%s" $imageTag }}
{{- end }}

{{- define "rawfile-csi.node-image-repository" -}}
{{- $imageRepo := (.Values.image.repository) }}
{{- printf "%s" $imageRepo }}
{{- end }}

{{- define "rawfile-csi.node-image" -}}
{{- $imageTag := .Values.node.image.tag | default (.Values.image.tag | default .Chart.AppVersion) }}
{{- $imageRegistry := .Values.image.registry | default .Values.global.imageRegistry }}
{{- printf "%s/%s:%s" $imageRegistry (include "rawfile-csi.node-image-repository" .) (include "rawfile-csi.node-image-tag" .) }}
{{- end }}

{{- define "rawfile-csi.node-pull-policy" -}}
{{- printf "%s" (.Values.image.pullPolicy | default .Values.global.imagePullPolicy) }}
{{- end }}

{{- define "rawfile-csi.node-resources" -}}
{{- toYaml (.Values.node.resources) }}
{{- end }}
