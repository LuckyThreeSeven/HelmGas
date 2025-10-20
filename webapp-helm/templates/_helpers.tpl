{{- define "neves.name.app" -}}
{{- .appName | printf "%s-app" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "neves.commonLabels" -}}
app.kubernetes.io/name: {{ .Values.teamName | quote}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | quote}}
app.kubernetes.io/managed-by: Helm
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/part-of: {{ .Chart.Name | quote}}
app.kubernetes.io/component: {{ .component | quote }}
app: {{ include "neves.name.app" . | quote}}
{{- end -}}

{{- define "neves.name.deploy" -}}
{{- printf "%s-deploy" (include "neves.name.app" .) -}}
{{- end -}}

{{- define "neves.name.svc" -}}
{{- printf "%s-svc" (include "neves.name.app" .) -}}
{{- end -}}

{{- define "neves.name.container" -}}
{{- printf "%s-container" (include "neves.name.app" .) -}}
{{- end -}}

{{- define "neves.name.configmap" -}}
{{- printf "%s-configmap" (include "neves.name.app" .) -}}
{{- end -}}

{{- define "neves.name.secret" -}}
{{- printf "%s-secret" (include "neves.name.app" .) -}}
{{- end -}}

{{- define "neves.name.gw" -}}
{{- printf "%s-gw" (include "neves.name.app" .) -}}
{{- end -}}

{{- define "neves.name.pvc" -}}
{{- printf "%s-pvc" (include "neves.name.app" .) -}}
{{- end -}}

{{- define "neves.name.pv" -}}
{{- printf "%s-pv" (include "neves.name.app" .) -}}
{{- end -}}

{{- define "neves.name.httproute" -}}
{{- printf "%s-httproute" (include "neves.name.app" .) -}}
{{- end -}}

{{- define "neves.name.serviceentry" -}}
{{- printf "%s-external" . -}}
{{- end -}}

{{- define "neves.name.auth" -}}
{{- printf "%s-auth" . -}}
{{- end -}}