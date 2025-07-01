# ArgoCD Application: nginx-prometheus (WordPress)

## Overview

This repository defines the ArgoCD `Application` resource for deploying the `nginx-prometheus` WordPress application into our Kubernetes cluster. Following GitOps principles, this configuration ensures that our WordPress instance is continuously synchronized with the desired state defined in its source Git repository.

## Application Details

* **Application Name:** `nginx-prometheus`
* **Target Namespace:** `nginx-prometheusapp`
* **Application Type:** `WordPress`
* **ArgoCD Project:** `default`

## Source Code Repository

The Kubernetes manifests (Deployment, Service, PVC, etc.) for the WordPress `nginx-prometheus` are located in a separate Git repository:

* **Repository URL:** `https://github.com/manaspradhan007/argocd-release-repo.git`
* **Path within Repo:** `applications/nginx-prometheus`
* **Target Revision:** `main`

## Deployment Strategy

This ArgoCD Application is configured with an **Automated Sync Policy**, ensuring that any changes committed to the source Git repository for `nginx-prometheus` are automatically applied to the Kubernetes cluster.

* **`automated: true`**: ArgoCD will continuously monitor the Git repository for changes.
* **`prune: true`**: Resources no longer defined in Git will be automatically removed from the cluster.
* **`selfHeal: true`**: If the live state of resources in the cluster drifts from the Git-defined state, ArgoCD will automatically revert them.
* **`CreateNamespace=true`**: The `nginx-prometheusapp` namespace will be automatically created if it doesn't already exist in the target cluster.

## How it Works

1.  **ArgoCD Application Definition:** This `Application` resource (`applications/nginx-prometheus/nginx-prometheus.yaml`) is committed to *this* Git repository.
2.  **ArgoCD Discovery:** Your ArgoCD instance (running in the `argocd` namespace) is configured to discover `Application` resources from this repository.
3.  **Synchronization:** Upon discovery, ArgoCD reads the `nginx-prometheus` Application definition. It then connects to the `https://github.com/manaspradhan007/argocd-release-repo.git` repository, navigates to the `applications/nginx-prometheus` path, and compares the Kubernetes manifests found there with the current state of the `nginx-prometheus` namespace in your cluster.
4.  **Automated Deployment:** Any differences detected trigger an automatic synchronization, applying the desired state to the cluster.

## Accessing the Application

Once deployed by ArgoCD, your WordPress `nginx-prometheus` will be accessible via its configured Ingress.

* **WordPress URL:** `http(s)://wordpress.task.de` (Replace with your actual WordPress Ingress URL)
* **ArgoCD UI:** `http(s)://argocd.task.de` (Replace with your actual ArgoCD Ingress URL) : https://87.106.77.61:8082/
Credentials:
user: admin
password: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d

## Files in this Directory

* `nginx-prometheusapp-values.yaml`: The Kubernetes manifest defining the ArgoCD `Application` resource for the WordPress `nginx-prometheus`.

## Prerequisites

* A running Kubernetes cluster.
* ArgoCD installed and configured in your cluster (typically in the `argocd` namespace).
* The Git repository containing the WordPress application manifests (`https://github.com/manaspradhan007/argocd-release-repo.git`) must be accessible by ArgoCD.

## Deployment Steps (Manual for this Application Definition)

To deploy this ArgoCD Application definition:

1.  Ensure you have `kubectl`, `helm` configured to connect to your Kubernetes cluster.
2.  Apply the `Application` manifest:

## Command to create ArgoCD App:

```
argocd app create my-wordpress-app \
  --repo https://github.com/manaspradhan007/argocd-release-repo.git \
  --path applications/nginx-prometheus \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace nginx-prometheusapp \
  --project wordpress-app \
  --sync-policy Automatic \
  --auto-prune \
  --self-heal
```