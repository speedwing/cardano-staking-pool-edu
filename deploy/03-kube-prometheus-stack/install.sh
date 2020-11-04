#!/bin/bash
helm upgrade --install kube-prometheus-stack -n observe prometheus-community/kube-prometheus-stack -f values-rpi.yaml
