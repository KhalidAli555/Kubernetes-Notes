ls
swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter
# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
# Verify that the br_netfilter, overlay modules are loaded by running the following commands:
lsmod | grep br_netfilter
lsmod | grep overlay
# Verify that the net.bridge.bridge-nf-call-iptables, net.bridge.bridge-nf-call-ip6tables, and net.ipv4.ip_forward system variables are set to 1 in your sysctl config by running the following command:
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
curl -LO https://github.com/containerd/containerd/releases/download/v1.7.14/containerd-1.7.14-linux-amd64.tar.gz
sudo tar Cxzvf /usr/local containerd-1.7.14-linux-amd64.tar.gz
curl -LO https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mkdir -p /usr/local/lib/systemd/system/
sudo mv containerd.service /usr/local/lib/systemd/system/
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl daemon-reload
sudo systemctl enable --now containerd
# Check that containerd service is up and running
systemctl status containerd
curl -LO https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64
sudo install -m 755 runc.amd64 /usr/local/sbin/runc
curl -LO https://github.com/containernetworking/plugins/releases/download/v1.5.0/cni-plugins-linux-amd64-v1.5.0.tgz
sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.5.0.tgz
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet=1.29.6-1.1 kubeadm=1.29.6-1.1 kubectl=1.29.6-1.1 --allow-downgrades --allow-change-held-packages
sudo apt-mark hold kubelet kubeadm kubectl
kubeadm version
kubelet --version
kubectl version --client
sudo crictl config runtime-endpoint unix:///var/run/containerd/containerd.sock
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=172.31.89.68 --node-name master
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter
# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system
# Verify that the br_netfilter, overlay modules are loaded by running the following commands:
lsmod | grep br_netfilter
lsmod | grep overlay
# Verify that the net.bridge.bridge-nf-call-iptables, net.bridge.bridge-nf-call-ip6tables, and net.ipv4.ip_forward system variables are set to 1 in your sysctl config by running the following command:
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
curl -LO https://github.com/containerd/containerd/releases/download/v1.7.14/containerd-1.7.14-linux-amd64.tar.gz
sudo tar Cxzvf /usr/local containerd-1.7.14-linux-amd64.tar.gz
curl -LO https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mkdir -p /usr/local/lib/systemd/system/
sudo mv containerd.service /usr/local/lib/systemd/system/
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl daemon-reload
sudo systemctl enable --now containerd
# Check that containerd service is up and running
systemctl status containerd
curl -LO https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.amd64
sudo install -m 755 runc.amd64 /usr/local/sbin/runc
curl -LO https://github.com/containernetworking/plugins/releases/download/v1.5.0/cni-plugins-linux-amd64-v1.5.0.tgz
sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.5.0.tgz
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet=1.29.6-1.1 kubeadm=1.29.6-1.1 kubectl=1.29.6-1.1 --allow-downgrades --allow-change-held-packages
sudo apt-mark hold kubelet kubeadm kubectl
kubeadm version
kubelet --version
kubectl version --client
sudo crictl config runtime-endpoint unix:///var/run/containerd/containerd.sock
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=172.31.16.248 --node-name master
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=172.31.16.248 --node-name master --v=5
sudo kubeadm reset -f
sudo rm -rf /etc/cni/net.d
sudo rm -rf $HOME/.kube
sudo systemctl restart containerd
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=172.31.16.248 --node-name master
mkdir -p $HOME/.kube
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/tigera-operator.yaml
curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/custom-resources.yaml -O
kubectl apply -f custom-resources.yaml
kubectl get nodes
kubectl get nodes -A
kubectl get pods -A
kubectl create deployment nginx --image=nginx
kubectl get pods
kubectl expose deployment nginx --type=NodePort --port=80
kubectl get deployment
kubectl get svc
kubectl get deployment
kubectl delete deployment nginx
kubectl get svc
kubectl delete svc nginx
kubectl get pods
kubectl get pods pA
kubectl get pods -A
kubectl get nodes
kubectl get nodes -o wide
git clone https://github.com/KhalidAli555/TWSThreeTierAppChallenge.git
ls
cd TWSThreeTierAppChallenge/
ls
cd backend
ls
npm start
sudo apt install npm
ls
node index.js
npm install dotenv
node index.js
cd ..
ls
cd kubernetes-Manifests-file
cd Kubernetes-Manifests-file
ls
cd backend
cd Backend/
ls
nano service.yaml
cd ..
ls
cd Frontend/
ls
nano service.yaml
ls
nano deployment.yaml 
nano service.yaml 
nano deployment.yaml 
ls
cd ..
cd Backend/
ls
nano service.yaml 
nano deployment.yaml 
nano service.yaml 
nano deployment.yaml 
cd ..
cd Frontend/
ls
cat deployment.yaml 
cat service.yaml 
nano deployment.yaml 
nano service.yaml 
cd ..
cd Backend/
nano deployment.yaml 
nano service.yaml 
cd ..
ls
cd Database/
ls
cat deployment.yaml 
cat service.yaml 
cd ..
cd Frontend/
ls
cd ..
ls
cd frontend/
ls
cat Dockerfile 
nano Dockerfile 
docker build -t tws-frontend-threetier:latest .
sudo apt install docker
sudo apt install docker.io
docker build -t tws-frontend-threetier:latest .
sudo docker build -t tws-frontend-threetier:latest .
lsblk
sudo growpart /dev/xvda 1
sudo resize2fs /dev/xvda1
lsblk
df -h
sudo docker build -t tws-frontend-threetier:latest .
sudo docker images
cd ..
ls
cd Kubernetes-Manifests-file/
cd Backend/
ls
nano deployment.yaml 
c ..
cd ..
cd 
cd TWSThreeTierAppChallenge/
cd Kubernetes-Manifests-file/
cd Frontend/
nano deployment.yaml 
sudo docker images
sudo docker tag tws-backend-threetier:latest khalidali07/tws-backend-threetier:latest
docker images
sudo docker images
ls
cd TWSThreeTierAppChallenge/
ls
cd frontend/
npm install
npm start
nanp package.json
nano package.json
npm start
ls
nano .env
npm start
cd ..
cd backend/
ls
cat Dockerfile 
sudo docker build -t tws-backend-threetier:latest .
ls
docker images
sudo docker images
sudo docker tag tws-frontend-threetier:latest khalidali07/tws-frontend-threetier:latest
sudo docker images
docker login
sudo docker push khalidali07/tws-frontend-threetier:latest
sudo docker images
sudo docker push khalidali07/tws-frontend-threetier:latest
docker logout
sudo docker login
sudo docker push khalidali07/tws-frontend-threetier:latest
sudo docker push khalidali07/tws-backend-threetier:latest
cd ..
ls
cd Kubernetes-Manifests-file/
cd Backend/
ls
nano deployment.yaml 
cd ..
cd Frontend/
nano deployment.yaml 
cd ..
kubectl get ns
