# Kubernetes Manifest for Application

## Folder Structure
- `config/`: Contains configuration files such as ConfigMap and Secrets.
- `deployments/`: Contains deployment manifests for MongoDB, backend, and frontend.
- `services/`: Contains service manifests to expose the applications.
- `volumes/`: Contains persistent volume claims for MongoDB.

## How to Deploy
1. Apply the PVC:
   ```bash
   kubectl apply -f volumes/mongodb-pvc.yaml