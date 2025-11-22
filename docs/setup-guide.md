# k3s Homelab Setup Guide

Step-by-step guide for deploying a basic k3s cluster with optional high-availability components.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Install First Control Plane Node](#install-first-control-plane-node)
3. [Deploy Kube-VIP](#deploy-kube-vip)
4. [Deploy MetalLB](#deploy-metallb)
5. [Configure kubectl](#configure-kubectl)
6. [Test Deployment](#test-deployment)

---

## Prerequisites

* Linux server (e.g., Ubuntu Server or Debian)
* At least 2 CPU cores and 2 GB RAM
* Static or reserved IP (recommended)
* SSH access with sudo privileges

---

## Install First Control Plane Node

SSH into the server:

```bash
ssh user@NODE1_IP
```

Install k3s (cluster-init mode):

```bash
curl -sfL https://get.k3s.io | sh -s - server \
  --cluster-init \
  --tls-san=VIP_ADDRESS \
  --disable servicelb \
  --write-kubeconfig-mode=644
```

Verify the node:

```bash
kubectl get nodes
```

Retrieve the join token (for adding more nodes):

```bash
sudo cat /var/lib/rancher/k3s/server/node-token
```

---

## Deploy Kube-VIP

Apply the Kube-VIP DaemonSet:

```bash
kubectl apply -f kubernetes/manifests/kube-vip/daemonset.yaml
```

Check status:

```bash
kubectl get pods -n kube-system -l app=kube-vip
```

(Optional) Test VIP:

```bash
ping VIP_ADDRESS
```

---

## Deploy MetalLB

Install MetalLB:

```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.0/config/manifests/metallb-native.yaml
```

Wait for pods:

```bash
kubectl wait -n metallb-system \
  --for=condition=ready pod \
  --selector=app=metallb \
  --timeout=90s
```

Apply address pool (generic placeholders):

```bash
kubectl apply -f kubernetes/manifests/metallb/config.yaml
```

---

## Configure kubectl

On your workstation:

```bash
mkdir -p ~/.kube
scp user@NODE1_IP:/etc/rancher/k3s/k3s.yaml ~/.kube/config
```

Update the `server:` field to point to the VIP:

```yaml
server: https://VIP_ADDRESS:6443
```

Test connection:

```bash
kubectl get nodes
```

---

## Test Deployment

Deploy a sample app:

```bash
kubectl apply -f kubernetes/manifests/apps/example/
```

Check service:

```bash
kubectl get svc
```

Access using the IP assigned from MetalLB.
