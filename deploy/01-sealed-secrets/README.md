# Sealed Secrets

Install on kube:

`helm install --namespace kube-system --name sealed-secrets stable/sealed-secrets`

* [Project home](https://github.com/helm/charts/tree/master/stable/sealed-secrets)

## Create Block Producer secrets

NETWORK=mainnet; kubectl create secret generic cardano-node-producer-secret \
    -n cardano-staking-${NETWORK} \
    --dry-run=client -o yaml  \
    --from-file=kes.skey \
    --from-file=vrf.skey \
    --from-file=node.cert  | kubeseal -o yaml --cert sealed-secret.crt > cardano-staking-certs-${NETWORK}.yaml
