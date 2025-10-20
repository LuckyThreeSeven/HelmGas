{{- define "neves.name.app" -}}
{{- .app.name | printf "%s-app" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "neves.commonLabels" -}}
app.kubernetes.io/name: {{ .Values.teamName | quote}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | quote}}
app.kubernetes.io/managed-by: Helm
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/part-of: {{ .Chart.Name | quote}}
app: {{ include "neves.name.app" . | quote}}
{{- end -}}

{{- define "neves.name.deploy" -}}
{{- printf "%s-deploy" .app.name -}}
{{- end -}}

{{- define "neves.name.svc" -}}
{{- printf "%s-svc" .app.name -}}
{{- end -}}

{{- define "neves.name.container" -}}
{{- printf "%s-container" .app.name -}}
{{- end -}}

{{- define "neves.name.configmap" -}}
{{- printf "%s-configmap" .app.name -}}
{{- end -}}

{{- define "neves.name.secret" -}}
{{- printf "%s-secret" .app.name -}}
{{- end -}}

{{- define "neves.name.pvc" -}}
{{- printf "%s-pvc" .app.name -}}
{{- end -}}

{{- define "neves.name.pv" -}}
{{- printf "%s-pv" .app.name -}}
{{- end -}}

{{- define "neves.name.serviceentry" -}}
{{- printf "%s-external" . -}}
{{- end -}}

{{- define "neves.name.auth" -}}
{{- printf "%s-auth" . -}}
{{- end -}}

{{- define "neves.name.gw" -}}
{{- printf "%s-gw" . -}}
{{- end -}}

{{- define "neves.name.httproute" -}}
{{- printf "%s-httproute" . -}}
{{- end -}}

{{- define "neves.svc.path" -}}
{{ printf "%s.%s.svc.cluster.local" (include "neves.name.svc" .) .Values.teamName }}
{{- end -}}

{{- define "neves.snipet.deploy" -}}
appVersion: v1
kind: Deployment
metadata:
  name: {{ include "neves.name.deploy" . }}
  namespace: {{ .Values.teamName }}
  labels:
    {{- include "neves.commonLabels" . | nindent 4 }}
spec:
  replicas: {{ .app.replicas }}
  selector:
  matchLabels:
    app: {{ include "neves.name.app" . }}
  template:
    metadata:
      labels:
        {{- include "neves.commonLabels" . | nindent 8 }}
    spec:
      containers:
        - name: {{ include "neves.name.container" . }}
          image: {{ printf "%s/%s:%s" .Values.image.root .app.image.repo .app.image.tag }}
          ports:
            - containerPort: {{ .app.ports.container }}
{{- if or .app.config .app.secret }}
          env:
  {{- if .app.config }}
            - configMapRef:
                name: {{ include "neves.name.configmap" . }}
  {{- end -}}
  {{- if .app.secret }}
            - configMapRef:
                name: {{ include "neves.name.secret" . }}
  {{- end -}}
{{- end -}}
{{- end -}}

{{- define "neves.snipet.svc.cluster" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "neves.name.svc" . }}
  namespace: {{ .Values.teamName }}
  labels:
    {{- include "neves.commonLabels" . | nindent 4 }}
spec:
  selector:
    app: {{ include "neves.name.app" . }}
  type: ClusterIP
  ports:
  {{- range $name, $val := .app.ports }}
    - name: {{ $name }}
      protocol: {{ $val.protocol }}
      port: {{ $val.service }}
      targetPort: {{ $val.container }}
  {{ end -}}
{{- end -}}

{{- define "neves.snipet.cm.header" -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "neves.name.configmap" . }}
  namespace: {{ .Values.teamName }}
  labels:
    {{- include "neves.commonLabels" . | nindent 4 }}
{{- end -}}

{{- define "neves.snipet.secret.header" -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "neves.name.configmap" . }}
  namespace: {{ .Values.teamName }}
  labels:
    {{- include "neves.commonLabels" . | nindent 4 }}
{{- end -}}

