# 🏠 Homelab Kubernetes Infrastructure

> Production-grade Kubernetes homelab built with k3s, focusing on high availability, automation, and cloud-native practices.

[![k3s](https://img.shields.io/badge/k3s-v1.33.5-326CE5?logo=kubernetes)](https://k3s.io/)
[![MetalLB](https://img.shields.io/badge/MetalLB-v0.14-blue)](https://metallb.universe.tf/)
[![Kube--VIP](https://img.shields.io/badge/Kube--VIP-v0.8-green)](https://kube-vip.io/)
[![Status](https://img.shields.io/badge/status-active-success)](https://github.com/lamonega/homelab)

## 📋 Overview

This repository documents my Kubernetes homelab, designed to learn and demonstrate modern DevOps/SRE workflows:

* High Availability with multi-node control plane
* Fully declarative configuration
* Load balancing, service discovery, and automation
* Hands-on practice with cloud-native tooling

---

## 🖥️ Infrastructure

### Current (Phase 1)

* **Node 1**: Debian 12, Control Plane + Worker
* **Cluster datastore**: etcd

### Planned (Phase 2)

* Additional control-plane nodes
* Lightweight DNS device

### Network Architecture

* Control plane virtual IP (kube-vip)
* LoadBalancer address pool (MetalLB)

---

## 🛠️ Technology Stack

* **Kubernetes**: k3s
* **Container Runtime**: containerd
* **CNI**: Flannel
* **Storage**: Local Path Provisioner
* **Load Balancing**: kube-vip + MetalLB
* **Management**: kubectl, Kubernetes manifests
* **Automation (planned)**: Ansible

---

## 🗺️ Roadmap

### Phase 1 — Foundation

* Single-node cluster
* kube-vip setup
* MetalLB
* Remote kubectl
* First applications

### Phase 2 — High Availability

* Add nodes
* Validate etcd quorum
* VIP and failover testing

### Phase 3 — Advanced Features

* Ingress controller
* cert-manager
* Prometheus/Grafana
* Loki/Promtail
* ArgoCD

### Phase 4 — Automation & Security

* Ansible provisioning
* Sealed Secrets
* Velero backups
* Network & security policies

---

## 📧 Contact

Built by **Laureano Francisco Lamonega**
[LinkedIn](https://linkedin.com/in/lamonega)
[Email](mailto:lamonega@proton.me)
