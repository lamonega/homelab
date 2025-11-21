#!/bin/bash
# K3s Master Node Installation Script
# Run this on the first master node

set -e

# Configuration
VIP="192.168.5.100"
NODE_IP=$(hostname -I | awk '{print $1}')

echo "Installing k3s on ${NODE_IP} with VIP ${VIP}..."

curl -sfL https://get.k3s.io | sh -s - server \
  --cluster-init \
  --tls-san=${VIP} \
  --tls-san=${NODE_IP} \
  --disable servicelb \
  --write-kubeconfig-mode 644

echo "Waiting for k3s to be ready..."
sleep 10

# Verify installation
sudo systemctl status k3s --no-pager

echo ""
echo "✅ K3s installed successfully!"
echo ""
echo "Save this token for adding additional nodes:"
sudo cat /var/lib/rancher/k3s/server/node-token
echo ""
echo "Next steps:"
echo "1. Deploy Kube-VIP: kubectl apply -f kubernetes/manifests/kube-vip/daemonset.yaml"
echo "2. Install MetalLB: kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.0/config/manifests/metallb-native.yaml"
echo "3. Configure MetalLB: kubectl apply -f kubernetes/manifests/metallb/config.yaml"
