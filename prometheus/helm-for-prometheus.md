🚀 Step 2: Install kube-prometheus-stack

This is the full package:

- Prometheus

- Grafana

- Alertmanager

- Node exporter

- Kube-state-metrics

- All ServiceMonitors & PodMonitors support built-in

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

```bash
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
```
