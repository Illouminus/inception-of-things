This README describes how to:

- install Docker, k3d and kubectl  
- create a local k3d cluster  
- install Argo CD  
- deploy the `wil42/playground` demo app  
- connect everything via GitOps (Argo CD watching a Git branch)

1. Install Docker, k3d and kubectl
```
chmod +x scripts/install.sh
./scripts/install.sh
su - $USER
```
To check:
```
docker --version
kubectl version --client
k3d version
```
2. Create the k3d cluster
The script:
- checks if a cluster named iot-cluster already exists
- creates it with:
    - 1 server + 1 agent
    - host port 8888 → NodePort 30080 (demo app)
    - host port 8080 → NodePort 30081 (Argo CD UI)
```
chmod +x scripts/create_cluster.sh
./scripts/create_cluster.sh
```
To check:
```
k3d cluster list
kubectl get nodes -o wide
```
3. Create namespaces

Manifests:
- configurations/namespaces/argocd-namespace.yaml
- configurations/namespaces/dev-namespace.yaml
```
kubectl apply -f configurations/namespaces/argocd-namespace.yaml
kubectl apply -f configurations/namespaces/dev-namespace.yaml
```
To check:
```
kubectl get ns
```
4. Install Argo CD
The script:
- applies the argocd namespace manifest
- installs Argo CD from the official upstream manifest
- waits for all Argo pods to become Ready
- patches argocd-server to NodePort 30081 (HTTP on port 80)

```
chmod +x scripts/install_argocd.sh
./scripts/install_argocd.sh
```
To check:
```
kubectl get pods -n argocd
kubectl get svc -n argocd
```
Get Argo CD admin password (login admin)
```
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d; echo
```
5. Deploy the demo application (playground)

Manifests:
- configurations/app/deployment.yaml
(uses image wil42/playground:v1 in namespace dev)
- configurations/app/service.yaml
(NodePort 30080 → container port 8888)
```
kubectl apply -f configurations/app/deployment.yaml
kubectl apply -f configurations/app/service.yaml
```
To check:
```
kubectl get pods -n dev
kubectl get svc -n dev
curl http://localhost:8888/
```
6. Configure Argo CD Application (GitOps)
```
kubectl apply -f configurations/argocd/application.yaml -n argocd
```
To check:
```
kubectl get applications -n argocd
```
Argo CD UI: http://localhost:8080
Watch cluster and inspect the deployment:
```
watch -n 2 kubectl get pods -n dev
kubectl describe deployment playground -n dev | grep -i Image
```
7. Cleanup
To delete the k3d cluster:
```
k3d cluster delete iot-cluster
```