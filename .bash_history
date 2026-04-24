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
ls
cd TWSThreeTierAppChallenge/
ls
cd Kubernetes-Manifests-file/
ls
nano namespace.yaml
kubectl apply -f namespace.yaml 
kubectl get ns
ls
cd Database/
ls
cat pv.yaml
cat pvc.yaml
ls
cat secrets.yaml
kubectl apply -f pv.yaml
kubectl apply -f pcv.yaml
kubectl apply -f pvc.yaml
ls
kubectl apply -f deployment.yaml 
kubectl apply -f service.yaml 
kubectl get deployments -n three-tier
kubectl get pods -n three-tier
ls
nano deployment.yaml 
kubectl delete deployment mongodb
kubectl delete deployment mongodb -n three-tier
kubectl delete svc mongo-svc -n three-tier
kubectl get svc
nano service.yaml 
kubectl get svc
kubectl get pv
kubectl get pvc
kubectl get svc -n three-tier
kubectl delete mongodb-svc -n three-tier
kubectl delete svc mongodb-svc -n three-tier
kubeclt get pv -n three-tier
kubectl get pv -n three-tier
kubectl apply -f deployment.yaml 
kubectl apply -f service.yaml 
kubectl get deployment
kubectl get deployment -n three-tier
cd ..
ls
cd Backend/
ls
cd ..
cd Database/
ls
kubectl apply -f secrets.yaml 
kubectl get deployments -n three-tier
kubectl get pods -n three-tier
kubectl describe pod mongodb-77754765f7-p44g8
kubectl describe pod mongodb-77754765f7-p44g8 -n three-tier
ls
cat secrets.yaml 
kubectl get secretes -n three-tier
kubectl get secrete -n three-tier
kubectl get secrets -n three-tier
cat secrets.yaml 
kubectl get pod -n three-ther
kubectl get pod -n three-tier
kubectl get pvc -n three-tier
kubectl logs mongodb-77754765f7-p44g8 -n three-tier
kubectl describe pvc mongo-volume-claim -n three-tier
kubectl logs mongodb-77754765f7-p44g8 -n three-tier
nano deployment.yaml 
cat deployment.yaml 
nano deployment.yaml 
kubectl get deployment
kubectl get deployment -n three-tier
kubectl delete deployment -n three-tier
kubectl delete deployment mongodb -n three-tier
kubectl apply -f deployment.yaml 
kubectl get pods -n three-tier
kubectl logs mongodb-565df49dbb-7hldf -n three-tier
nano deployment.yaml 
kubectl delete deployment mongodb -n three-tier
kubectl apply -f deployment.yaml 
kubectl get pods -n three-tier
kubectl get deployments -n three-tier
cd ..
cd Backend/
ls
kubeclt apply -f deployment.yaml 
kubectl apply -f deployment.yaml 
kubectl get pods -n three-tier
kubeclt delete deployment backend -n three-tier
kubectl delete deployment backend -n three-tier
kubectl get pods -n three-tier
df -h
free -h
sudo docker system prune -af
free -h
kubectl get pods -n three-tier
kubectl logs mongodb-5fff87d48d-qnkt8 -n thre-tier
kubectl logs mongodb-5fff87d48d-qnkt8 -n three-tier
kubectl get pods -n three-tier
cd ..
cd Database/
ls
nano deployment.yaml 
kubectl get pods -n three-tier
cd ..
cd Backend/
nano deployment.yaml 
kubectl apply -f deployment.yaml 
kubectl get pods -n three-tier
kubectl get deployments -n three-tier
kubectl get pods -n three-tier
kubectl describe pod backend-6b69d654fb-b299w -n three-tier
kubectl get pods -n three-tier
kubeclt delete deployment backend -n three-tier
kubectl delete deployment backend -n three-tier
kubectl get pods -n three-tier
free -h
kubectl get pods -n three-tier
kubectl delete mongodb-5fff87d48d-qnkt8 -n three-tier
kubectl delete  pod mongodb-5fff87d48d-qnkt8 -n three-tier
kubectl delete pod mongodb-5fff87d48d-gp2sx -n three-tier
kubectl get pods -n three-tier
kubectl describe mongodb-5fff87d48d-dnwxm -n three-tier
kubectl describe  pod mongodb-5fff87d48d-dnwxm -n three-tier
kubectl get pods -n three-tier
kubectl delete pod mongodb-5fff87d48d-dnwxm -n three-tier
kubectl get pods -n three-tier
kubectl get nodes --show-labels
kubectl get pods -n three-tier
kubectl label node ip-172-31-29-177 node-role.kubernetes.io/worker=""
ls
cat deployment.yaml 
nano deployment.yaml 
kubectl apply -f deployment.yaml 
kubectl get pods -n three-tier
kubectl descrie pod backend-9687dc4b7-5q2cx -n three-tier
kubectl describe pod backend-9687dc4b7-5q2cx -n three-tier
kubectl get secrets -n three-tier
cat deployment.yaml 
nano deployment.yaml 
kubectl get pods -n three-tier
kubectl delete deployment backend -n three-tier
kubectl get pods -n three-tier
kubectl delete pod  mongodb-5fff87d48d-9ndpn -n three-tier
kubectl delete pod  mongodb-5fff87d48d-kfhtn -n three-tier
kubectl get pods -n three-tier
kubectl delete pods mongodb-5fff87d48d-bchqk -n three-tier
kubectl get pods -n three-tier
kubectl describe pod mongodb-5fff87d48d-hzc8s -n three-tier
kubectl get pods -n three-tier
kubectl taint nodes master node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get pods -n three-tier
kubectl apply -f deployment.yaml 
kubectl get pods -n three-tier
kubectl describe pod backend-6d5f5d86b7-4xprr -n three-tier
kubectl get pods -n three-tier
kubectl taint nodes ip-172-31-29-177 node.kubernetes.io/disk-pressure:NoSchedule-
kubectl get pods -n three-tier
kubectl describe node ip-172-31-29-177
kubectl get pods -n three-tier
kubectl delete pod backend-6d5f5d86b7-4xprr -n three-tier
kubectl rollout restart deployment backend -n three-tier
kubectl get pods -n three-tier
sudo docker images
cd
ls
git init
git add .
git commit -m "initial commit"
ls
nano .gitignore
git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/KhalidAli555/TWSThreeTierAppChallenge-v2.git
git push -u origin main
kubectl get nodes
ls
cd TWSThreeTierAppChallenge/
LS
ls
cd Kubernetes-Manifests-file/
ls
kubectl get pods -n three-tier
kubectl delete pod mongodb-5fff87d48d-hzc8s -n three-tier
kubectl delete pod backend-f59f6475d-kd8dt -n three-tier
kubectl get pods -n three-tier
kubectl describe backend-f59f6475d-dmjfw -n three-tier
kubectl describe pod backend-f59f6475d-dmjfw -n three-tier
kubectl describe pod mongodb-5fff87d48d-8jmfd -n three-tier
kubectl logs backend-f59f6475d-dmjfw -n three-tier
ls
cd Database/
ls
cat deployment.yml
cat deployment.yaml
cd ..
cd Backend/
cat deployment.yaml 
ls
cd ..
cd D
cd Database/
ls
cat secrets.yaml 
kubectl delete secret mongo-sec -n three-tier
nano secrets.yaml 
kubectl get deployments -n three-tier
kubectl delete deployments backend -n three-tier
kubectl get deployments -n three-tier
kubectl get svc -n three-tier
kubectl apply -f secrets.yaml
kubectl get pvc -n three-tier
cd ..
cd Backend/
kubectl apply -f deployment.yaml 
kubectl apply -f service.yaml 
kubectl get pods -n three-tier
kubectl describe pod backend-6d5f5d86b7-d4cfd -n three-tier
kubectl get nodes --show-labels
nano .env
df -h
docker system prune -a
nano deployment.yaml 
kubectl appy -f deployment.yaml 
kubectl apply -f deployment.yaml 
kubectl get pods -n three-tier
kubectl describe pod backend-7ff57757b4-qv7wh -n three-tier
kubectl get pods -n three-tier
kubectl logs -f backend-7ff57757b4-qv7wh -n three-tier
cd ..
cd Database/
ls
nano secrets.yaml 
kubectl apply -f secrets.yaml 
cd ..
cd Backend/
ls
nano deployment.yaml 
kubectl apply -f deployment.yaml 
kubectl get pods -n three-tier
kubectl describe pod backend-76b8d8bd76-l52cf -n three-tier
kubectl logs backend-76b8d8bd76-l52cf -n three-tier
cat service.yaml 
nano service.yaml 
kubectl apply -f service.yaml 
kubectl get svc -n three-tier
cd ..
cd Frontend/
ls
nano service.yaml 
cd ..
cd frontend/
nano .env
ls
docker build -t khalidali07/tws-frontend-threetier:01 .
sudo docker build -t khalidali07/tws-frontend-threetier:01 .
docker push khalidali07/tws-frontend-threetier:01
sudo docker push khalidali07/tws-frontend-threetier:01
sudo docker images
ls
cd ..
cd Kubernetes-Manifests-file/
LS
cd Frontend/
ls
nano deployment.yaml 
cat deployment.yaml 
cat service.yaml 
kubectl get pods -n three-tier
kubectl get svc -n three-tier
kubectl apply -f deployment.yaml 
kubectl get pods -n three-tier
kubectl logs frontend-88898fcfd-bt2b2 -n three-tier
kubectl get pods -n three-tier
kubectl logs frontend-88898fcfd-wrjhs -n three-tier
kubectl get pods -n three-tier
kubectl delete deployment frontend -n three-tier
kubectl get pods -n three-tier
cd ..
cd frontend/
ls
cat Dockerfile 
nano Dockerfile 
sudo docker build -t khalidali07/tws-frontend-threetier:02 .
docker push khalidali07/tws-frontend-threetier:02
sudo docker push khalidali07/tws-frontend-threetier:02
sudo docker images
cd ..
cd Kubernetes-Manifests-file/
ls
cd Frontend/
nano deployment.yaml 
cat deployment.yaml 
cat service.yaml 
kubectl apply -f deployment.yaml 
kubectl get pods -n three-tier
kubectl apply -f service.yaml 
kubectl get svc -n thre-tier
kubectl get svc -n three-tier
kubectl get pods -n three-tier
kubectl get svc -n three-tier
kubectl describe svc frontend -n three-tier
kubectl get pods -n three-tier
cd ..
ls
cd frontend/
ls
nano Dockerfile 
docker build -t khalidali07/tws-frontend-threetier:03 .
sduo docker build -t khalidali07/tws-frontend-threetier:03 .
sudo docker build -t khalidali07/tws-frontend-threetier:03 .
docker push khalidali07/tws-frontend-threetier:03
sudo docker push khalidali07/tws-frontend-threetier:03
cd ..
cd Kubernetes-Manifests-file/
ls
cd Frontend/
ls
nano deployment.yaml 
kubectl apply -f deployment.yaml 
kubectl get pods -n three-tier
cat deployment.yaml 
kubectl get pods -n three-tier
kubectl delete deployment frontend -n three-tier
kubectl get pods -n three-tier
kubectl delete pod backend-76b8d8bd76-l52cf -n three-tier
kubectl apply -f deployment.yaml 
kubectl get pods -n three-tier
kubectl describe pod frontend-79d75b8644-2nqhb -n three-tier
kubectl logs frontend-79d75b8644-2nqhb -n three-tier
cd ..
cd frontend/
cat Dockerfile 
cd ..
cd frontend/
nano Dockerfile 
cd ..
cd frontend
cd ..
cd Kubernetes-Manifests-file/
cd Frontend/
nano deployment.yaml 
kubectl apply -f deployment.yaml 
kubectl get pods -n three-tier
kubectl logs frontend-85974856b9-n8wq9 -n three-tier
kubectl get svc -n three-tier
ls
cd
ls
git init
git add .
git commit -m "initial comit"
git remote add origin https://github.com/KhalidAli555/TWSThreeTierAppChallenge-v2.git
git push -u origin main
kubectl get svc -n thre-tier
kubectl get svc -n thrre-tier
kubectl get svc -n three-tier
kubectl delete svc backend frontend mongo-svc -n three-tier
kubectl delete svc backend frontend mongodb-svc -n three-tier
kubectl get svc -n three-tier
kubectl get pv -n three-tier
kubectl delete pv mongo-pv -n three-tier
kubectl get deployment -n three-tier
kubectl delete all --all -n three-tier
kubectl get all -n three-tier
kubectl get nodes
kubectl get nodes -o wide
ls
cd TWSThreeTierAppChallenge/
ls
cd Kubernetes-Manifests-file/
ls
cd Frontend/
ls
nano deployment.yaml 
cd TWSThreeTierAppChallenge/
cd Kubernetes-Manifests-file/
ls
cd Frontend/
ls
nano deployment.yaml
cd ..
kubectl get all
kubectl get all -n three-tier
kubetl get ns
kubectl get ns
cd Database/
ls
kubectl apply -f secrets.yaml 
kubectl apply -f pv.yaml 
kubectl apply -f pvc.yaml 
kubectl get pvc -n thre-tier
ls
cd ..
ls
kubectl apply -f namespace.yaml 
kubectl ge ns
kubectl get ns
ls
cd Database/
ls
kubectl apply -f deployment.yaml 
kubectl apply -f service.yaml
kubectl get pods -n three-tier
kubectl get pods -o wide
kubectl get pods -o wide -n three-tier
kubectl get deployment.yaml -n three-tier
kubectl get deployment -n three-tier
cd ..
cd B
cd Backend/
ls
kubectl apply -f deployment.yaml 
kubectl apply -f service.yaml 
kubectl get pods -n thre-tier
kubectl get pods -n three-tier
kubectl get pods -n three-tier -o wide
kubectl describe pod backend-76b8d8bd76-7thsn -n three-tier
kubectl get pods -n three-tier -o wide
kubectl delete pod backend-76b8d8bd76-7thsn -n three-tier
kubectl delete pod mongodb-5fff87d48d-kr28d -n three-tier
kubectl get pods -n three-tier -o wide
free -h
sudo docker images
kubectl get pods -n three-tier -o wide
kubectl get pods -n  three-tier
cd TWSThreeTierAppChallenge/
cd Kubernetes-Manifests-file/
cf 
cd F
cd Frontend/
ls
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml 
kubectl get pods -n three-tier
kubectl get pods -n three-tier -o wide
kubectl get svc -n three-tier
kubectl logs backend-76b8d8bd76-fbcd8 -n three-tier
curl http://3.208.15.197:30007/ok
kubectl logs frontend-74ff54b844-nll7q -n three-tier
kubectl exec -it frontend-74ff54b844-nll7q -n three-tier -- curl http://backend:5000/ok
cat service.yaml 
nano service.yaml 
kubectl get pods -n three-tier
kubectl get pods -n three-tier -o wide
ubectl apply -f service.yaml 
cd TWSThreeTierAppChallenge/
cd Kubernetes-Manifests-file/
cd Frontend/
kubeclt apply -f service.yaml 
kubectl apply -f service.yaml 
kubectl get svc -n three-tier
nano service.yaml 
kubectl apply -f service.yaml 
kubectl get svc -n three-tier
nano service.yaml 
kubectl delete svc frontend -n three-tier
kubectl delete svc frontend-lb -n three-tier
kubectl get svc -n three-tier
cat service.yaml 
kubectl apply -f service.yaml 
cat service.yaml 
kubectl get svc -n three-tier
kubectl get pods -n three-tier
sudo netstat -tulnp | grep 30353
ls
cd ..
ls
kubectl delete ns namespace.yaml 
kubectl delete ns three-tier
kubectl get pods 
kubectl get pods  -n three-tier
kubectl get all -n three-tier
kubectl get nodes
ls
cd TWSThreeTierAppChallenge/
ls
cd Kubernetes-Manifests-file/
ls
cd Backend/
ls
cat service.yaml 
nano service.yaml 
cd ..
ls
cd Frontend/
cat service.yaml 
nano service.yaml 
cd
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
kubectl get ns
kubectl get pods -n ingress-nginx
cd TWSThreeTierAppChallenge/
cd Kubernetes-Manifests-file/
ls
cat ingress.yaml 
ls
kubectl delete ingress.yaml
nano ingress.yaml 
kubectl get pods -n ingress-nginx -o wide
nano /etc/hosts
sudo nano /etc/hosts
cat /etc/hosts
sudo nano /etc/hosts
cd TWSThreeTierAppChallenge/
cd Kubernetes-Manifests-file/
ls
cd Frontend/
ls
nano deployment.yaml
cd ..
cd Database/
ls
kubectl apply -f secrets.yaml
kubectl apply -f namespace.yaml
cd ..
ls
kubectl get pods -n namespace.yaml 
kubectl apply -f  namespace.yaml 
ls
cd Database/
kubectl apply -f secrets.yaml 
kubectl apply -f pv.yaml 
kubectl apply -f pvc.yaml 
ls
kubectl apply -f se
kubectl apply -f service.yaml 
kubectl get pods -n three-tier
kubectl apply -f deployment.yaml 
kubectl get pods -n three-tier
cd ..
cd Backend/
ls
kubectl apply -f deployment.yaml 
kubectl apply -f service.yaml 
kubectl get pods -n three-tier
kubectl get pods -n three-tier -o wide
kubectl svc -n three-tier
kubectl get svc -n three-tier
cd ..
cd Frontend/
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml 
kubectl get pods -n three-tier
kubectl get pods -n three-tier -o wide
ls
cd ..
ls
kubectl apply -f ingress.yaml 
kubectl get ingress -n three-tier
kubectl get svc -n three-tier
kubectl get ingress -n three-tier
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx
cat /etc/hosts
ls
nano ingress.yaml 
kubectl apply -f ingress.yaml 
nano ingress.yaml 
kubectl apply -f ingress.yaml 
kubectl get ingress -n three-tier
cd
ls
cd TWSThreeTierAppChallenge/
cd frontend/
nano .env
cd ..
cd Kubernetes-Manifests-file/
cd Frontend/
nano deployment.yaml
kubectl apply -f deployment.yaml
kubectl get pods -n three-tier
kubectl get svc -n three-tier
kubectl get svc -n ingress-nginx
kubectl get pods -n three-tier -o wide
kubectl exec -it frontend-849df7b568-p4llk -n three-tier -- curl http://backend:5000/api/tasks
kubectl logs backend-76b8d8bd76-ngrjt -n three-tier
kubectl get svc -n ingress-nginx
cd ..
ls
nano ingress.yaml 
kubectl apply -f ingress.yaml 
cat ingress.yaml 
kubectl get pods -n ingress-nginx
kubectl logs -n ingress-nginx ingress-nginx-controller-75cbbc5b68-djgrb
kubectl get svc -n three-tier
kubectl get pods -n three-tier -o wide
kubectl describe pod frontend-849df7b568-p4llk -n three-tier
kubectl get svc -n three-tier
kubectl get ingress - three-tier
kubectl get ingress -n three-tier
kubectl delete ingress three-tier-ingress -n three-tier
cd Frontend/
ls
nano service.yaml 
kubectl apply -f service.yaml 
kubectl get svc -n three-tier
sudo netstat -tulnp | grep 30080
sudo apt install netstat
sudo netstat -tulnp | grep 30080
sudo ufw status
sudo ufw allow 30080/tcp
sudo ufw reload
sudo ss -tulnp | grep 30080
cd ..
cd frontend/
ls
cat Dockerfile 
cd ..
cd Kubernetes-Manifests-file/
cd Frontend/
nano deployment.yaml
kubectl apply -f deployment.yaml
nano service.yaml 
kubectl apply -f
kubectl apply -f service.yaml 
kubectl get svc -n three-tier
nano deployment.yaml
kubect apply -f deployment.yaml
kubectl apply -f deployment.yaml
cd ..
cd Backend/
nano service.yaml 
kubectl apply -f service.yaml 
cd ..
cd
cd TWSThreeTierAppChallenge/
cd frontend/
nano .env
docker build -t khalidali07/tws-frontend-threetier:04 .
sudo docker build -t khalidali07/tws-frontend-threetier:04 .
docker push khalidali07/tws-frontend-threetier:04
sudo docker push khalidali07/tws-frontend-threetier:04
cd ..
cd Kubernetes-Manifests-file/
cd Frontend/
nano deployment.yaml
kubectl apply -f deployment.yaml
kubeclt get pods -n three-tier
kubectl get pods -n three-tier
ls
cd TWSThreeTierAppChallenge/
ls
cd Kubernetes-Manifests-file/
ls
kubectl delete namespace.yaml 
kubectl delete ns three-tier
cat ~/.kube/config
scp ~/.kube/config ubuntu@3.83.237.177:/home/ubuntu/
sudo scp ~/.kube/config ubuntu@3.83.237.177:/home/ubuntu/
ssh -i security-key.pem ubuntu@3.83.237.177
sudo ssh -i security-key.pem ubuntu@3.83.237.177
sudo nano security-key.pem
sudo chmod 400 security-key.pem 
sudo ssh -i security-key.pem ubuntu@3.83.237.177
ls
sudo scp ~/.kube/config ubuntu@3.83.237.177:/home/ubuntu/
sudo scp  ~/.kube/config ubuntu@3.83.237.177:/home/ubuntu/
sudo scp -i security-key.pem ~/.kube/config ubuntu@3.83.237.177:/home/ubuntu/
sudo netstat -tulnp | grep 6443
kubectl get pods -n kube-system
cd TWSThreeTierAppChallenge/
git add .
git remote -v
git commit -m "initial commit"
git status
git push origin main
git status
kubectl get nodes
docker images
sudo usermod -aG docker $USER
sudo usermod -aG docker jenkins
docker ps
docker images
sudo reboot
ls
kubectl get nodes
sudo reboot
kubectl get ns three-tier
kubectl get ns
cat ~/.kube/config
kubectl get nodes -A
kubectl get pods -A
kubectl get nodes
kubectl get pods -A
kubectl describe pod tigera-operator-76c4974c85-zzzvs
kubectl describe pod tigera-operator-76c4974c85-zzzvs -n tigera-operator
df -h
kubectl delete pods -n tigera-operator --all
ls
kubectl get pods -A
kubectl delete pod calico-apiserver-7cfbd57dd4-bzcck -n calico-apiserver
kubectl delete pod calico-apiserver-7cfbd57dd4-d66jx -n calico-apiserver
kubectl delete pod calico-apiserver-7cfbd57dd4-slnfc -n calico-apiserver
kubectl delete pod calico-apiserver-7cfbd57dd4-t7hjn -n calico-apiserver
kubectl get pods -A
kubectl get svc -A
cat ~/.kube/config
sudo apt update
sudo apt upgrade -y
sudo apt install openjdk-17-jdk -y
java -version
docker images
docker rmi <none>
docker rmi ef26f105cc9e ac58ecb95565 0e47b498adab  4da4660c0f90 4866cb6ac862
docker images
docker rmi node nginx node
docker rmi node:14 nginx:stable-alpine node:2--alpine
docker images
ls
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc   https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]"   https://pkg.jenkins.io/debian-stable binary/ | sudo tee   /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins -y
jenkins --version
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins
ls
cat /var/lib/jenkins/secrets/initialAdminPassword
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
sudo mkdir -p /var/lib/jenkins/.kube
sudo cp /etc/kubernetes/admin.conf /var/lib/jenkins/.kube/config
sudo chown -R jenkins:jenkins /var/lib/jenkins/.kube
sudo chmod 600 /var/lib/jenkins/.kube/config
ls
kubectl get nodes
kubectl get pods -A
sudo usermod -aG docker jenkins
sudo usermod -aG docker $USER
newgrp docker
kubectl get nodes
kubectl get pods -A
kubectl get deployments -n three-tier
kubectl get pods -n three-tier
kubectl get pods -n three-tier -o wide
kubectl descrebe pod mongodb-5fff87d48d-wmtjm -n three-tier
kubectl describe pod mongodb-5fff87d48d-wmtjm -n three-tier
kubectl get pvc -n three-tier
kubectl get pv -n three-tier
kubectl delete pv mongo-pv
cd TWSThreeTierAppChallenge/
ls
cd Kubernetes-Manifests-file/
ls
cd Database/
ls
kubectl apply -f pv.yaml -f pvc.yaml 
kubectl get pv -n three-tier
kubectl get pods -n three-tier
kubectl logs backend-56d979d4d8-zbh2f -n thre-tier
kubectl logs backend-56d979d4d8-zbh2f -n three-tier
kubectl get svc -n three-tier
cd
cd TWSThreeTierAppChallenge/
ls
cd frontend/
ls
nano .env
cd
cd TWSThreeTierAppChallenge/
git add .
git commit -m "new changes"
git push origin main
git pull origin main --rebase
git push origin main
cd Kubernetes-Manifests-file/
ls
kubectl delete ns three-tier
kubectl get pods -n three-tier
ls
kubectl get noes
kubectl get nodes
kubectl get nodes -o wide
kubectl get pods
kubectl get ns
mkdir k8s
ls
c k8s/
cd k8s/
nano deployment.yml
ls
sudo mv deployment.yml nginx-deployment.yml
ls
kubectl apply -f nginx-deployment.yml
kubectl get deployment
kubectl get pods
kubectl svc
kubectl get svc
kubectl get replicaset
ls
cd k8s/
ls
nano nginx-deployment.yml 
kubectl apply -f nginx-deployment.yml 
kubectl get pods
kubectl get svc
kubectl describe  pod nginx-deployment-7c79c4bf97-9frt9
kubectl logs nginx-deployment-7c79c4bf97-9frt9
kubectl delete -f nginx-deployment.yml
kubectl get pods
nano mongodb-deployment.yml
nano mongo-secret.yml
nano mongodb-deployment.yml 
nano mongo-config.yml
kubectl apply -f mongo-config.yml 
kubectl apply -f mongo-secret.yml
nano mongo-service.yml
cat mongo-config.yml 
nano mongo-config.yml 
kubectl apply -f mongo-config.yml 
kubectl apply -f mongodb-deployment.yml 
kubectl apply -f mongo-service.yml 
kubectl get pods 
kubectl get svc
kubectl describe pod mongodb-deployment-7bb68dcc8f-7vk6j   
kubectl get pods
kubectk get svc
kubectl get svc
kuectl describe svc mongo-service
kubectl describe svc mongo-service
kubectl describe svc mongodb-service
kubectl get nodes -o wide
kubectl get pods -o wide
kubectl get pods
cat mongo-config.yml 
nano mongoexpress-deployment.yml
nano mongoexpress-service.yml
kubectl apply -f mongoexpress-deployment.yml 
kubectl apply -f mongoexpress-service.yml 
kubectl get pods
kubectl describe pod mongo-express-654b849dd5-qj5f8
kubectl logs mongo-express-654b849dd5-qj5f8
kubectl exec -it mongo-express-654b849dd5-qj5f8 -- env | grep ME_CONFIG
ls
cat mongo-service.yml 
cat mongodb-deployment.yml 
ls
cat mongoexpress-deployment.yml 
kubectl delete -f mongoexpress-deployment.yml 
kubectl get pods
kubectl apply -f mongoexpress-deployment.yml 
kubectl get pods
kubectl logs mongo-express-654b849dd5-4sn2r
kubectl exec -it mongo-express-654b849dd5-4sn2r -- env | grep ME_CONFIG
cat mongoexpress-deployment.yml 
nano mongoexpress-deployment.yml 
ls
cat mongo-config.yml 
nano mongoexpress-deployment.yml 
cat mongo-secret.yml 
nano mongoexpress-deployment.yml 
kubectl apply -f mongoexpress-deployment.yml 
kubectl get pods
kubectl logs mongo-express-5d6555cfb6-rmhk7
nano mongoexpress-deployment.yml 
kubectl apply -f mongoexpress-deployment.yml 
kubectl get pods
kubectl logs mongo-express-6d4668448f-qbbg8
ls
kubectl get svc
cat mongo-secret.yml 
cat mongoexpress-service.yml 
ls
kubectl delete -f mongo-config.yml -f mongo-service.yml -f mongodb-deployment.yml -f mongo-secret.yml  -f monogexpress-deployment.yml
kubectl delete -f mongo-config.yml -f mongo-service.yml -f mongodb-deployment.yml -f mongo-secret.yml  -f mongoexpress-deployment.yml
kubectl delete -f mongo-config.yml -f mongo-service.yml -f mongodb-deployment.yml -f mongo-secret.yml  -f mongoexpress-deployment.yml -f mongoexpress-service.yml 
kubectl get all
cd ..
mkdir kubernetes.yml
ls
mv kubernetes.yml kubernetes
ls
cd kubernetes/
ls
nano mongo-secret.yml
nano mongo-configmap.yml
nano mongo-deployment.yml
ls
nano mongo-express.yml
ls
kubectl apply -f mongo mongo-configmap.yml 
kubectl apply -f mongo-configmap.yml 
kubectl apply -f mongo-secret.yml 
kubectl apply -f mongo-deployment.yml 
kubectl apply -f mongo-express.yml 
kubectl get pods
kubectl logs mongo-express-859f75dd4f-c84pv
kubectl get svc
ls
c kubernetes/
cd kubernetes/
ls
cat mongo-express.yml 
kubectl get pods
kubectl exec -it mongo-express-859f75dd4f-c84pv -- ping mongodb-service
kubectl get pods --all-namespaces
kubectl get svc --all-namespaces
kubectl get pods
kubectl logs mongodb-deployment-699744c7d-skft9 
kubectl describe pods mongodb-deployment-699744c7d-skft9 
kubectl get pods
kubectl logs mongo-express-859f75dd4f-c84pv
kubectl exec mongo-express-859f75dd4f-c84pv -- env | grep MONGO
kubectl get svc
kubectl get deployment mongo-express -o yaml
kubectl get configmap mongodb-configmap -o yaml
kubectl exec mongo-express-859f75dd4f-c84pv -- env | grep -E "ME_CONFIG|MONGO"
kubectl exec mongo-express-859f75dd4f-c84pv -- env | grep ME_CONFIG_MONGODB_SERVER
kubectl get deployment mongo-express -o yaml | grep -A 5 -B 5 ME_CONFIG_MONGODB_URL
ls
nano mongo-express.yml 
kubectl apply -f mongo-express.yml 
kubectl get pods
kubectl logs mongo-express-f57755567-mpshx
kubectl get svc
kubectl get nodes -o wide
cat mongo-express.yml 
ls
kubectl delete -f mongo-configmap.yml -f mongo-secret.yml 
kubectl delete -f mongo-configmap.yml -f mongo-secret.yml -f mongo-express.yml 
kubectl get pods
kubectl delete -f mongo-deployment.yml 
kubectl get pods
ls
cd ..
ls
rm -r k8s/
ls
kubectl get pods
kubectl get nodes
kubectl get pods
ls
mkdir sql-k8s
ls
cd sql-k8s/
nano mysql-secret.yml
ls
nano mysql-configmap.yml
nano mysql-deployment.yml
ls
nano mysql-service.yml
ls
kubectl apply -f mysql-secret.yml 
kubectl apply -f mysql-configmap.yml 
kubectl apply -f mysql-deployment.yml 
kubectl apply -f mysql-service.yml 
kubectl get pods
kubectl get svc
kubectl get all
kubectl describe service mysql-service
kubectl get pods -o wide
kubectl describe pod deployment.apps/mysql-deployment 
kubectl get pods
kubectl describe pod mysql-deployment-58844ffcfd-79kzh
kubectl logs mysql-deployment-58844ffcfd-79kzh
kubectl exec -it mysql-deployment-58844ffcfd-79kzh -- bash
ls
nano adminier-deployment.yml
nano adminer-service.yml
kubectl apply -f adminier-deployment.yml 
kubectl apply -f adminer-service.yml 
kubectl get pods
kubectl exec -it mysql-deployment-58844ffcfd-79kzh --bash
kubectl exec -it mysql-deployment-58844ffcfd-79kzh -- bash
ls
kubectl delete -f adminer-service.yml -f adminier-deployment.yml -f mysql-configmap.yml -f mysql-secret.yml -f mysql-deployment.yml -f mysql-service.yml 
kubectl get pods
kubectl get all
ls
kubectl get nodes
mkdir mysql-stateful
ls
cd mysql-stateful/
ls
nano secret.yml
nano service.yml
nano statefulset.yml
nano secret.yml 
nano configmap.yml
nano service.yml 
nanp statefulset.yml 
nano statefulset.yml 
ls
kubectl get pods
kubectl apply -f secret.yml 
kubectl apply -f configmap.yml 
kubectl apply -f statefulset.yml 
kubectl apply -f service.yml 
kubectl get pods
kubectl get svc
kubectl get pvc
kubectl get pods
nanp statefulset.yml 
nano statefulset.yml 
kubectl apply -f statefulset.yml 
kubectl get pods
kubectl describe pod mysql-0
kubectl get pods
kubectl get pv
kubectl get pvc
kubectl get sc
kubectl delete  pv mongo-pv
nano pv.yml
sudo mkdir -p /mnt/data/mysql-0
sudo chown 1000:1000 /mnt/data/mysql-0 
kubectl apply -f pv.yml 
kubectl get pv
kubectl get pvc
kuectl get pods
kuebctl get pods
kubectl get pods
kubectl describe pod mysql-1
kubectl get pods
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
kubectl get pods
kubectl get pvc
kubectl desvribe pv mysql-storage-mysql-1
kubectl describe pv mysql-storage-mysql-1
kubectl describe pvc mysql-storage-mysql-1
ls
kubectl delete -f configmap.yml -f pv.yml -f secret.yml -f service.yml -f statefulset.yml 
ls
kubectl get pods
kubectl get pv
kubectl get pvc
kubectl delete -f configmap.yml -f pv.yml -f secret.yml -f service.yml -f statefulset.yml 
kubectl get pv
kubectl delete mysql-pv-0
kubectl delete pv mysql-pv-0
ls
mysql-stateful/
ls
cd mysql-stateful/
ls
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=master"
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=v1.4.0"
kubectl version --short
kubeadm version
git clone https://github.com/kubernetes-sigs/aws-ebs-csi-driver.git
ls
cd aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr
ls
nano kustomization.yaml 
cat kustomization.yaml 
cd ../ecr-public
ls
nano kustomization.yaml 
cd mysql-stateful/
ls
rm -r aws-ebs-csi-driver/
rm -rf aws-ebs-csi-driver/
ls
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=master"
kubecyl version -- short
kubectl version -- short
kubectl version --short
kubectl --version
kubectl version
kubectl delete csidriver ebs.csi.aws.com
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=master"
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=v1.30.0"
kubectl get pods -n kube-system | grep ebs
kubectl delete pods -n kube-system -l app=ebs-csi-controller
kubectl delete pods -n kube-system -l app=ebs-csi-node
kubectl get pods -n kube-system | grep ebs
kubectl describe pod ebs-csi-controller-d99c78556-7dpm9 -n kube-system
kubectl delete pod -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver
kubectl get pods -n kube-system | grep ebs
kubectl describe pod ebs-csi-controller-d99c78556-t68ld
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 602401143452.dkr.ecr.us-west-2.amazonaws.com
sudo apt install aws-cli
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 602401143452.dkr.ecr.us-west-2.amazonaws.com
sudo apt install -y awscli
ls
cd mysql-stateful/
ls
cat configmap.yml 
cat secret.yml 
nano secret.yml 
ls
cat service.yml
cat statefulset.yml 
ls
kubectl get pvc
kubectl get pods
kubectl get svc
kubectl delete pvc mysql-storage-mysql-0
kubectl delete pvc mysql-storage-mysql-1
kubectl get pvc
ls
cd kubernetes/
ls
git init
git add kubernetes
cd ,,
ls
cd ..
ls
git add kubernetes
pwd
ls
git add kubernetes
cd kubernetes/
git add .
ls
cd kubernetes/
git add .
git commit -m "initial commit"
git branch -M main
git remote add origin https://github.com/KhalidAli555/Kubernetes-Notes.git
git push origin main
cd ..
ls
cd mysql-stateful/
ls
git add .
git commit -m "initial commit"
cd ..
ls
git branch
git add mysql-stateful/
git push origin main
git add set remote origin https://github.com/KhalidAli555/Kubernetes-Notes.git
git set remote origin https://github.com/KhalidAli555/Kubernetes-Notes.git
git status
git remote -v
[200~git remote set-url origin https://github.com/KhalidAli555/Kubernetes-Notes.git~
git remote set-url origin https://github.com/KhalidAli555/Kubernetes-Notes.git
git remote -v
ls
git add mysql-stateful
git push
git push -f origin main
git remote -v
ls
git remote -v
cd kubernetes/
git remote -v
cd..
cd ..
git add kubernetes/
git add .
ls
