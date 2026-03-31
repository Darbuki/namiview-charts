# namiview-charts

Helm charts for the Namiview underwater image restoration platform.

## Charts

| Chart | Description | Ports |
|-------|-------------|-------|
| `namiview-api` | FastAPI backend -- inference, auth, storage | 8000 (API), 9090 (metrics) |
| `namiview-ui` | React/nginx frontend | 80 |

## Multi-Environment Strategy

Each chart uses three values files consumed by ArgoCD:

- **`values.yaml`** -- shared defaults (image repo, probes, resource limits)
- **`values-dev.yaml`** -- 1 replica, dev image tag, dev vault paths
- **`values-prod.yaml`** -- 2 replicas, prod image tag, prod domain

Image tags in `values-dev.yaml` and `values-prod.yaml` are updated automatically by GitHub Actions in the `namiview` repo on every build. ArgoCD detects the commit and rolls out the new version.

## What Each Chart Deploys

### namiview-api

| Resource | Purpose |
|----------|---------|
| Deployment | FastAPI pod with startup, readiness, and liveness probes |
| Service | ClusterIP on ports 8000 + 9090, ClientIP session affinity |
| ExternalSecret (connection) | MongoDB and MinIO credentials from Vault |
| ExternalSecret (google-creds) | Google OAuth credentials from Vault |
| ExternalSecret (jwt) | JWT signing secret from Vault |
| ExternalSecret (dockercfg) | Registry pull credentials from Vault |
| ServiceMonitor | Prometheus scrape config for port 9090 |
| NetworkPolicy | Scoped ingress/egress rules |
| ConfigMap | Grafana dashboard JSON |
| PodDisruptionBudget | Availability guarantee during maintenance |

### namiview-ui

| Resource | Purpose |
|----------|---------|
| Deployment | React/nginx pod with readiness and liveness probes |
| Service | ClusterIP on port 80, ClientIP session affinity |
| ExternalSecret (dockercfg) | Registry pull credentials from Vault |

## Security

All secrets pulled at runtime via ExternalSecret resources backed by Vault. Health probes, PodDisruptionBudget, resource limits, and NetworkPolicy enforced on the API chart.

## CI/CD Flow

```
namiview repo (push) --> GitHub Actions builds + pushes images
                     --> updates image tag in values-{dev,prod}.yaml
                     --> ArgoCD syncs --> rolling deployment
```

## Related Repositories

| Repository | Purpose |
|---|---|
| [namiview](https://github.com/Darbuki/namiview) | Application source (FastAPI + React) |
| [namiviewk8s](https://github.com/Darbuki/namiviewk8s) | ArgoCD apps and infrastructure manifests |
| [namiview-base](https://github.com/Darbuki/namiview-base) | Base Docker image (Python 3.12 + PyTorch CPU) |
