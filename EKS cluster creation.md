# EKS cluster creation

#### 

#### Install Docker



sudo apt-get update

sudo apt install docker.io

docker ps

sudo chown $USER /var/run/docker.sock



#### Install kubectl

curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin

kubectl version --short --client



#### Install eksctl



curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl\_$(uname -s)\_amd64.tar.gz" | tar xz -C /tmp

sudo mv /tmp/eksctl /usr/local/bin

eksctl version



#### Setup EKS Cluster



eksctl create cluster --name three-tier-cluster --region us-west-2 --node-type t2.medium --nodes-min 2 --nodes-max 2

aws eks update-kubeconfig --region us-west-2 --name three-tier-cluster

kubectl get nodes



#### Run Manifests



kubectl create namespace workshop

kubectl apply -f .

kubectl delete -f .



#### Install AWS Load Balancer



curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam\_policy.json

aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam\_policy.json

eksctl utils associate-iam-oidc-provider --region=us-west-2 --cluster=three-tier-cluster --approve

eksctl create iamserviceaccount --cluster=three-tier-cluster --namespace=kube-system --name=aws-load-balancer-controller --role-name AmazonEKSLoadBalancerControllerRole --attach-policy-arn=arn:aws:iam::626072240565:policy/AWSLoadBalancerControllerIAMPolicy --approve --region=us-west-2



#### Deploy AWS Load Balancer Controller





sudo snap install helm --classic

helm repo add eks https://aws.github.io/eks-charts

helm repo update eks

helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=my-cluster --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller

kubectl get deployment -n kube-system aws-load-balancer-controller

kubectl apply -f full\_stack\_lb.yaml

