# 🏠 Homelab Kubernetes Infrastructure

> Production-grade Kubernetes homelab built with k3s, focusing on high availability, automation, and cloud-native practices.

[![k3s](https://img.shields.io/badge/k3s-v1.33.5-326CE5?logo=kubernetes)](https://k3s.io/)
[![MetalLB](https://img.shields.io/badge/MetalLB-v0.14-blue)](https://metallb.universe.tf/)
[![Kube--VIP](https://img.shields.io/badge/Kube--VIP-v0.8-green)](https://kube-vip.io/)
[![Status](https://img.shields.io/badge/status-active-success)](https://github.com/lamonega/homelab)

## 📋 Table of Contents
- [Overview](#overview)
- [Infrastructure](#infrastructure)
- [Technology Stack](#technology-stack)
- [Architecture](#architecture)
- [Quick Start](#quick-start)
- [Demo](#demo)
- [Documentation](#documentation)
- [Roadmap](#roadmap)

## 🎯 Overview

This repository documents my homelab infrastructure, designed to demonstrate DevOps/SRE practices and cloud-native technologies. The setup emphasizes:

- **High Availability**: Multi-master k3s cluster with automated failover
- **Infrastructure as Code**: All configurations version-controlled and reproducible
- **Production Practices**: Load balancing, networking, and service discovery
- **Continuous Learning**: Hands-on experience with enterprise-grade tools

## 🖥️ Infrastructure

### Current Setup (Phase 1)
- **Node 1 (marcelo)**: Control Plane + Worker
  - IP: 192.168.5.11
  - OS: Ubuntu Server 24.04 LTS
  - Role: etcd member, control-plane, worker

### Planned Expansion (Phase 2)
- **Node 2**: Control Plane + Worker (192.168.5.12)
- **Node 3**: Control Plane + Worker (192.168.5.13)

### Network Configuration
- **Subnet**: 192.168.5.0/24
- **Control Plane VIP**: 192.168.5.100 (managed by Kube-VIP)
- **Service LoadBalancer Pool**: 192.168.5.150-160 (managed by MetalLB)
- **Gateway**: 192.168.5.1

## 🛠️ Technology Stack

### Core Infrastructure
- **Kubernetes Distribution**: [k3s](https://k3s.io/) v1.33.5
- **Container Runtime**: containerd
- **CNI Plugin**: Flannel
- **Storage**: Local-path provisioner

### High Availability Components
- **Control Plane HA**: Embedded etcd (3-node quorum ready)
- **API LoadBalancer**: [Kube-VIP](https://kube-vip.io/) v0.8.0 (ARP mode)
- **Service LoadBalancer**: [MetalLB](https://metallb.universe.tf/) v0.14.0 (Layer 2)

### Management Tools
- **CLI**: kubectl (Arch Linux workstation)
- **IaC**: Raw Kubernetes manifests (Ansible planned)

## 🏗️ Architecture
```
                    ┌──────────────────┐
                    │   Workstation    │
                    │  kubectl (Arch)  │
                    └────────┬─────────┘
                             │
                             │ HTTPS:6443
                             ▼
                    ┌──────────────────┐
                    │   Kube-VIP       │
                    │  192.168.5.100   │◄─── Virtual IP (HA)
                    └────────┬─────────┘
                             │
                    ┌────────▼─────────┐
                    │  Master Node 1   │
                    │  192.168.5.11    │
                    │                  │
                    │  • etcd member   │
                    │  • control-plane │
                    │  • worker        │
                    └──────────────────┘
                             │
                    ┌────────▼─────────┐
                    │     MetalLB      │
                    │  Service LB Pool │
                    │ .150 - .160      │
                    └──────────────────┘
                             │
                             ▼
                    [ User Applications ]
```

Future architecture with 3 nodes: [docs/architecture.md](docs/architecture.md)

## 🚀 Quick Start

### Prerequisites
- Ubuntu Server 24.04 LTS (or compatible)
- Minimum 2GB RAM per node
- Static IP or DHCP reservation
- SSH access

### Installation

**1. Install k3s on first master:**
```bash
./kubernetes/scripts/install-k3s-master.sh
```

**2. Deploy Kube-VIP:**
```bash
kubectl apply -f kubernetes/manifests/kube-vip/daemonset.yaml
```

**3. Install MetalLB:**
```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.0/config/manifests/metallb-native.yaml
kubectl apply -f kubernetes/manifests/metallb/config.yaml
```

**4. Test with nginx:**
```bash
kubectl apply -f kubernetes/manifests/apps/nginx-example/
```

For detailed instructions, see [docs/setup-guide.md](docs/setup-guide.md)

## 🎬 Demo

### Working LoadBalancer with MetalLB

MetalLB automatically assigns external IPs to LoadBalancer services:
```bash
$ kubectl get svc nginx-lb
NAME       TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
nginx-lb   LoadBalancer   10.43.237.12   192.168.5.151   80:30127/TCP   5s

$ curl http://192.168.5.151
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
...
```

✅ Service is accessible from any device on the network!

### High Availability Test
```bash
# VIP responds even when primary node changes
$ ping 192.168.5.100
PING 192.168.5.100 56(84) bytes of data.
64 bytes from 192.168.5.100: icmp_seq=1 ttl=64 time=0.5 ms
64 bytes from 192.168.5.100: icmp_seq=2 ttl=64 time=0.4 ms
```

## 📚 Documentation

- [Setup Guide](docs/setup-guide.md) - Complete installation walkthrough
- [Architecture](docs/architecture.md) - System design and components
- [Networking](docs/networking.md) - IP allocation and network config
- [Troubleshooting](docs/troubleshooting.md) - Common issues and solutions

## 🗺️ Roadmap

### Phase 1: Foundation ✅
- [x] Single-node k3s cluster
- [x] Kube-VIP for control plane HA readiness
- [x] MetalLB for service load balancing
- [x] kubectl remote access
- [x] Basic application deployment (nginx)

### Phase 2: High Availability (In Progress)
- [ ] Add 2 additional master nodes
- [ ] Test etcd quorum and failover
- [ ] Verify VIP failover between nodes
- [ ] Load balancer redundancy validation

### Phase 3: Advanced Features
- [ ] Ingress controller (Traefik/Nginx)
- [ ] Certificate management (cert-manager)
- [ ] Monitoring stack (Prometheus + Grafana)
- [ ] Centralized logging (Loki + Promtail)
- [ ] GitOps workflow (ArgoCD)

### Phase 4: Automation & Security
- [ ] Ansible automation for cluster provisioning
- [ ] Secrets management (Sealed Secrets)
- [ ] Backup strategy (Velero)
- [ ] Security hardening (Pod Security Standards)
- [ ] Network policies

## 💡 Skills Demonstrated

### Currently Implemented
- ✅ Linux system administration (Ubuntu Server)
- ✅ Container orchestration (Kubernetes/k3s)
- ✅ High availability architecture design
- ✅ Load balancing and service mesh concepts
- ✅ Infrastructure as Code (manifests)
- ✅ Networking (VIPs, Layer 2 networking)
- ✅ Documentation and knowledge sharing

### In Development
- 🔄 Multi-node cluster management
- 🔄 Automation (Ansible playbooks)
- 🔄 Monitoring and observability

## 📝 Notes

This is a learning project documenting my journey into DevOps and cloud-native technologies. All configurations are production-ready patterns scaled down for homelab use.

## 📧 Contact

Built by [Laureano Francisco Lamonega]  
[LinkedIn](https://linkedin.com/in/lamonega) | [Email](mailto:lamonega@proton.me)

---

**Last Updated**: November 2025  
**Status**: 🟢 Active Development
