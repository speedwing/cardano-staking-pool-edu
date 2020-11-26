# ArgoCD cluster bootstrap

Bootstrapping cluster w/ ArgoCD

Steps:

```bash
helm repo add argo https://argoproj.github.io/argo-helm
kubectl create ns argocd
helm install --name argocd -n argocd argo/argo-cd
```