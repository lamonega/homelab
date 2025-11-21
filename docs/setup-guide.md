# K3s Homelab Setup Guide

Complete step-by-step guide for setting up k3s with HA capabilities.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Network Planning](#network-planning)
3. [Install First Master](#install-first-master)
4. [Deploy Kube-VIP](#deploy-kube-vip)
5. [Deploy MetalLB](#deploy-metallb)
6. [Configure kubectl](#configure-kubectl)
7. [Test Deployment](#test-deployment)

## Prerequisites

- Ubuntu Server 24.04 LTS
- Minimum 2GB RAM, 2 CPU cores
- Static IP or DHCP reservation
- SSH access with sudo privileges

## Network Planning

| Component | IP Address | Purpose |
|-----------|------------|---------|
| Node 1 | 192.168.5.11 | Control Plane + Worker |
| Node 2 (future) | 192.168.5.12 | Control Plane + Worker |
| Node 3 (future) | 192.168.5.13 | Control Plane + Worker |
| **VIP** | **192.168.5.100** | **Kubernetes API (HA)** |
| MetalLB Pool | 192.168.5.150-160 | Service LoadBalancer IPs |

## Install First Master

SSH into your first node:
```bash
ssh user@192.168.5.11
```

Run the installation script:
```bash
curl -sfL https://get.k3s.io | sh -s - server \
  --cluster-init \
  --tls-san=192.168.5.100 \
  --tls-san=192.168.5.11 \
  --disable servicelb \
  --write-kubeconfig-mode 644
```

Verify:
```bash
sudo systemctl status k3s
sudo kubectl get nodes
```

Save the join token:
```bash
sudo cat /var/lib/rancher/k3s/server/node-token
```

## Deploy Kube-VIP

Apply the manifest:
```bash
kubectl apply -f kubernetes/manifests/kube-vip/daemonset.yaml
```

Verify VIP is up:
```bash
kubectl get pods -n kube-system | grep kube-vip
ping -c 4 192.168.5.100
```

## Deploy MetalLB

Install MetalLB:
```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.0/config/manifests/metallb-native.yaml
```

Wait for pods:
```bash
kubectl wait --namespace metallb-system \
  --for=condition=ready pod \
  --selector=app=metallb \
  --timeout=90s
```

Configure IP pool:
```bash
kubectl apply -f kubernetes/manifests/metallb/config.yaml
```

## Configure kubectl

On your workstation:
```bash
mkdir -p ~/.kube
scp user@192.168.5.11:/etc/rancher/k3s/k3s.yaml ~/.kube/config
```

Edit `~/.kube/config` and change:
```yaml
server: https://127.0.0.1:6443
```
to:
```yaml
server: https://192.168.5.100:6443
```

Test:
```bash
kubectl get nodes
```

## Test Deployment

Deploy nginx:
```bash
kubectl apply -f kubernetes/manifests/apps/nginx-example/
```

Check service:
```bash
kubectl get svc nginx-lb
```

Access in browser: `http://192.168.5.151` (or your assigned IP)

## Next Steps

- Add additional master nodes (Phase 2)
- Deploy monitoring stack
- Configure ingress controller
- Set up GitOps with ArgoCD

---

For troubleshooting, see [troubleshooting.md](troubleshooting.md)
