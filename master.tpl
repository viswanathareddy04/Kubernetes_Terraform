#!/bin/bash -x
## https://www.cloudtechnologyexperts.com/kubeadm-on-aws/

sudo apt-get update

sudo apt-get install -y apt-transport-https

sudo su -
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update

apt-get install -y docker.io

apt-get install -y kubelet kubeadm kubectl kubernetes-cni

echo "####### kubeadm config images pull ########## "
kubeadm config images pull


echo "Kubeadm Init"
kubeadm init --pod-network-cidr=10.244.0.0/16

# echo "############## Installing a CNI Network. ##############"
# sysctl net.bridge.bridge-nf-call-iptables=1

# export kubever=$(kubectl version | base64 | tr -d '\n')

# kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"


#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config

# kubectl get nodes

# kubectl get pods --all-namespaces

kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml