
## How I set up FluxCD  

- How to install on the control node 

```bash
kubectl apply -f https://github.com/fluxcd/flux2/releases/latest/download/install.yaml
```

- once installed then version check to see if it did it correctly 

```bash
flux --version
kubectl get pods -n flux-system
```

### first thing is installing the cli

```bash
curl -s https://fluxcd.io/install.sh | sudo bash
```
Then set up a Kustomization.yaml file to auto apply your new changes to your manifests 

### Example of Kustomization

``` yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: homelab
  namespace: flux-system
spec:
  interval: 1m0s
  path: "./clusters/main-cluster"
  prune: true
  sourceRef:
    kind: GitRepository
    name: homelab-repo
```

```bash
kubectl apply -f kustomization.yaml
```


