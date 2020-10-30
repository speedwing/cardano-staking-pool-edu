# Kube Prometheus Stack

Ref. https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack


## Install / Upgrade

helm upgrade --install kube-prometheus-stack -n observe prometheus-community/kube-prometheus-stack -f values-rpi.yaml 