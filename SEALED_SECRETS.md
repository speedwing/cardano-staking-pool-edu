# kubeseal

NETWORK=testnet; KUBESEAL_CERT_PATH=sealed-secret.crt; kubectl create secret generic cardano-node-producer-secret \
    --dry-run=client -o yaml \
    -n cardano-staking-"${NETWORK}2" \
    --from-file=kes.skey \
    --from-file=vrf.skey \
    --from-file=node.cert \
    | kubeseal --cert ${KUBESEAL_CERT_PATH} -o yaml > cardano-staking-certs-${NETWORK}.yaml