# Kube Prometheus Stack

Ref. https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

And https://github.com/helm/charts/tree/master/stable/kube-state-metrics

## Install / Upgrade

helm upgrade --install kube-prometheus-stack -n observe prometheus-community/kube-prometheus-stack -f values-rpi.yaml

## microk8s
https://github.com/ubuntu/microk8s/issues/1576

## Gotcha

When installed w/ a PVC, permissions are messed.

`sudo chown -R 1000:2000 .`
 