{{/*
# Copyright (c) 2020 Bell Canada
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
*/}}

{{- define "common.namespace" -}}
  {{- default .Release.Namespace .Values.nsPrefix -}}
{{- end -}}


{{/*
  Expand the name of a chart.
  The function takes from one to two arguments (inside a dictionary):
     - .dot : environment (.)
     - .suffix : add a suffix to the name
*/}}
{{- define "common.name" -}}
  {{- $dot := default . .dot -}}
  {{- $suffix := .suffix -}}
  {{- default $dot.Chart.Name $dot.Values.nameOverride | trunc 63 | trimSuffix "-" -}}{{ if $suffix }}{{ print "-" $suffix }}{{ end }}
{{- end -}}

{{/*
  The same as common.full name but based on passed dictionary instead of trying to figure
  out chart name on its own.
*/}}
{{- define "common.fullnameExplicit" -}}
  {{- $dot := .dot }}
  {{- $name := .chartName }}
  {{- $suffix := default "" .suffix -}}
  {{- printf "%s-%s-%s" (include "common.release" $dot) $name $suffix | trunc 63 | trimSuffix "-" | trimSuffix "-" -}}
{{- end -}}

{{/*
  Create a default fully qualified application name.
  Truncated at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
  Usage:
      include "common.fullname" .
      include "common.fullname" (dict "suffix" "mySuffix" "dot" .)
  The function takes from one to two arguments:
     - .dot : environment (.)
     - .suffix : add a suffix to the fullname
*/}}
{{- define "common.fullname" -}}
{{- $dot := default . .dot -}}
{{- $suffix := default "" .suffix -}}
  {{- $name := default $dot.Chart.Name $dot.Values.nameOverride -}}
  {{- include "common.fullnameExplicit" (dict "dot" $dot "chartName" $name "suffix" $suffix) }}
{{- end -}}

{{/*
  Retrieve the "original" release from the component release:
  if ONAP is deploy with "helm deploy --name toto", then cassandra components
  will have "toto-cassandra" as release name.
  this function would answer back "toto".
*/}}
{{- define "common.release" -}}
  {{- first (regexSplit "-" .Release.Name -1)  }}
{{- end -}}

{{- define "common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  Resolve the name of the common image repository.
  The value for .Values.repository is used by default,
  unless either override mechanism is used.

  - .Values.global.repository  : override default image repository for all images
  - .Values.repositoryOverride : override global and default image repository on a per image basis
*/}}
{{- define "common.repository" -}} 
  {{if .Values.repositoryOverride }}
    {{- printf "%s" .Values.repositoryOverride -}} 
  {{else}}
    {{- default .Values.repository .Values.global.repository -}} 
  {{end}}
{{- end -}} 

{{/*
  Resolve the name of a chart's service.

  The default will be the chart name (or .Values.nameOverride if set).
  And the use of .Values.service.name overrides all.

  - .Values.service.name: override default service (ie. chart) name
*/}}
{{/*
  Expand the service name for a chart.
*/}}
{{- define "common.servicename" -}} 
  {{- $name := default .Chart.Name .Values.nameOverride -}} 
  {{- default $name .Values.service.name | trunc 63 | trimSuffix "-" -}} 
{{- end -}} 

