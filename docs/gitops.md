# How I used Gitops with FluxCD



## How to check services

```bash
flux get sources git --all-namespaces
```


we can also run 

```bash
flux get kustomizations --all-namespaces
```

### 2. 🚀 Bootstrap with GitLab

Flux can be bootstrapped to a GitLab repo using:

```bash
flux bootstrap git \
  --url=https://gitlab.com/<your-org>/<your-repo> \
  --branch=main \
  --path=clusters/my-cluster \
  --token-auth
```

then any directory with `kustomization.yaml` flux with auto apply like
