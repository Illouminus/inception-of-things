

k3d cluster create mycluster

# Creating the namespaces
kubectl create namespace argocd
kubectl create namespace dev

# Installing argocd in the namespace
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Check the argoCD pods
kubectl get pods -n argocd

kubectl port-forward svc/argocd-server -n argocd 8000:443
