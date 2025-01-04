# Stocker---DevOps
# CI/CD Pipeline with ArgoCD, Jenkins, and Kubernetes

This project uses **ArgoCD**, **Jenkins**, and **Kubernetes** to automate the deployment process of applications.

## Technologies

### Jenkins
- Jenkins automates the build and testing of the application.
- It triggers the creation of Docker images and pushes them to a container registry.

### ArgoCD
- ArgoCD automates the deployment process.
- It syncs Kubernetes configurations from a Git repository and deploys the application to the Kubernetes cluster.

### Kubernetes
- Kubernetes manages the application by deploying it in containers.
- It automatically handles scaling, health checks, and recovery.

## How It Works
1. Code changes trigger Jenkins to build and test the application.
2. Jenkins pushes the new Docker image to a registry.
3. ArgoCD updates the Kubernetes deployment automatically with the new image.

These tools together create an automated pipeline that ensures faster and more reliable application delivery.
