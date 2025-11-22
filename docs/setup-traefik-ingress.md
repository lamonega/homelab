# Quick Traefik Ingress Controller Setup Guide

## Overview

Traefik is the default Ingress Controller in k3s. It enables routing multiple applications through a single external IP using hostnames or paths. This reduces IP usage and simplifies access to services.

---

## Prerequisites

* A running k3s cluster
* kubectl configured
* A LoadBalancer provider (e.g., MetalLB)

---

## Verify Traefik Installation

Traefik is enabled by default in k3s.

```bash
kubectl get pods -n kube-system | grep traefik
kubectl get svc -n kube-system traefik
```

If it's missing, reinstall k3s without disabling Traefik or deploy it manually via Helm.

---

## Create a Basic Ingress

### 1. Ensure your Service is ClusterIP

```yaml
apiVersion: v1
kind: Service
metadata:
  name: example-service
spec:
  type: ClusterIP
  selector:
    app: example
  ports:
  - port: 80
```

### 2. Create an Ingress resource

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
spec:
  rules:
  - host: example.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: example-service
            port:
              number: 80
```

Apply it:

```bash
kubectl apply -f ingress.yaml
```

Check:

```bash
kubectl get ingress
```

---

## DNS / Hostname Testing

If you don’t have DNS yet, add a temporary entry to your `/etc/hosts`:

```
INGRESS_IP   example.local
```

Now test in browser or via `curl`.

---

## Adding More Applications

Repeat the same pattern:

* Deploy the app with a **ClusterIP** service
* Create an Ingress with a unique hostname
* Add DNS or `/etc/hosts` entry

---

## Optional: Traefik Dashboard

You can expose the dashboard using another Ingress:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: traefik-dashboard
  namespace: kube-system
spec:
  rules:
  - host: traefik.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: traefik
            port:
              number: 9000
```
