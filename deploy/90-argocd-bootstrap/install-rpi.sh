#!/usr/bin/env bash
helm upgrade -i argocd argo/argo-cd --version 2.10.0 -n argocd -f values-base.yaml -f values-rpi.yaml
