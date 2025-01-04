#!/bin/bash

# Set error handling
set -e
set -o pipefail

# Function for logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a setup.log
}

# Start minikube
log "Starting minikube with docker driver..."
minikube start --driver=docker
if [ $? -ne 0 ]; then
    log "ERROR: Failed to start minikube"
    exit 1
fi

# Start port forwarding for ArgoCD
log "Setting up port forwarding for ArgoCD..."
nohup kubectl port-forward svc/argocd-server -n argocd 8080:443 --address 0.0.0.0 > port-forward.log 2>&1 &
PORT_FORWARD_PID=$!

# Wait a moment to ensure port forwarding is established
sleep 5

# Check if port forwarding is running
if ! ps -p $PORT_FORWARD_PID > /dev/null; then
    log "ERROR: Port forwarding failed to start"
    exit 1
fi
log "Port forwarding established with PID: $PORT_FORWARD_PID"

# Delete existing ECR credentials if they exist
log "Removing existing ECR credentials..."
kubectl delete secret ecr-credentials --namespace default || true

# Get ECR password and create new secret
log "Creating new ECR credentials..."
ECR_PASSWORD=$(aws ecr get-login-password --region us-east-1)
if [ -z "$ECR_PASSWORD" ]; then
    log "ERROR: Failed to get ECR password. Check AWS credentials."
    exit 1
fi

kubectl create secret docker-registry ecr-credentials \
    --docker-server=$AWS_ID.dkr.ecr.us-east-1.amazonaws.com \
    --docker-username=AWS \
    --docker-password="$ECR_PASSWORD" \
    --namespace default

if [ $? -ne 0 ]; then
    log "ERROR: Failed to create ECR credentials secret"
    exit 1
fi

log "Setup completed successfully"

# Save port forwarding PID for future reference
echo $PORT_FORWARD_PID > .port-forward.pid