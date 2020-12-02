#!/usr/bin/env bash

set +x

shopt -s expand_aliases
source "${HOME}/.bash_aliases"

ARGO_CD_VERSION=v1.7.10

if [[ -z "${BASE64_GITHUB_DEPLOY_KEY}" ]]; then
  echo "BASE64_GITHUB_DEPLOY_KEY is empty"
  echo "You can generate the key issueing echo <key> | base64 --wrap=0"
  exit 1
fi

cat > master-app.yaml << EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: master-app
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    repoURL: https://github.com/speedwing/cardano-staking-pool-edu.git
    targetRevision: HEAD
    path: kubernetes/applications/master-app

  destination:
    namespace: argocd
    server: https://kubernetes.default.svc

  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    validate: true
EOF

cat > values-base.yaml << EOF
server:
  config:
    repositories: |
      - url: https://github.com/speedwing/cardano-staking-pool-edu.git
      - url: https://github.com/bitnami-labs/sealed-secrets.git
      - url: https://prometheus-community.github.io/helm-charts
        name: prometheus-community
        type: helm
      - url: https://kubernetes-charts.storage.googleapis.com
        name: stable
        type: helm
EOF

cat > values-docker-amd64.yaml << EOF
global:
  image:
    repository: argoproj/argocd
    tag: ${ARGO_CD_VERSION}
EOF

cat > values-rpi.yaml << EOF
global:
  image:
    repository: speedwing/argocd
    tag: ${ARGO_CD_VERSION}-arm
server:
  service:
    type: LoadBalancer
    loadBalancerIP: 192.168.0.230
EOF

echo "Adding argo-helm repo to helm"
helm repo add argo https://argoproj.github.io/argo-helm

echo "Creating argocd Namespace"
kubectl create ns argocd

echo "Creating github deploy key Secret"
echo "apiVersion: v1
kind: Secret
metadata:
  name: github-deploy-key
  namespace: argocd
data:
  sshPrivateKey: ${BASE64_GITHUB_DEPLOY_KEY}
type: Opaque" | kubectl apply -f -

OS_ARCH=$(uname -m)
echo "OS ARCH: ${OS_ARCH}"

if [[ "${OS_ARCH}" = "aarch64" ]]; then
  helm upgrade -i argocd argo/argo-cd --version 2.10.0 -n argocd -f values-base.yaml -f values-rpi.yaml
elif [[ "${OS_ARCH}" = "x86_64" ]]; then
  helm upgrade -i argocd argo/argo-cd --version 2.10.0 -n argocd -f values-base.yaml -f values-docker-amd64.yaml
else
  echo "$OS_ARCH is currently not supported"
  exit 1
fi

# Install ArgoCD master-app
kubectl apply -f master-app.yaml

rm master-app.yaml values-base.yaml values-docker-amd64.yaml values-rpi.yaml
