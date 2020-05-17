#!/bin/bash
kubectl create ns flux
kubectl ns flux

kubectl apply -k fluxcd

kubectl delete secret flux-git-deploy
kubectl create secret generic flux-git-deploy --from-file=identity=$HOME/.ssh/rancher

# kubectl create ns flux-system
# kubectl ns flux-system

# kubectl apply -f flux.yaml

# kubectl delete secret flux-git-deploy
# kubectl create secret generic flux-git-deploy --from-file=identity=$HOME/.ssh/demo-app