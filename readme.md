# ArgoCD GitOps Repository: Application Definitions

This repository serves as the single source of truth for defining and managing our applications deployed via ArgoCD within our Kubernetes clusters. Following GitOps principles, all application deployments are declared here, enabling automated synchronization and version control of our application's desired state.

## Table of Contents

- [Overview](#overview)
- [Directory Structure](#directory-structure)
- [Key Application: nginx-prometheus (WordPress)](#key-application-nginx-prometheus-wordpress)
- [Deployment Strategy](#deployment-strategy)
- [How it Works](#how-it-works)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Accessing Applications](#accessing-applications)

---

## Overview

This repository contains ArgoCD `Application` resources. Each `Application` resource acts as a pointer to an external Git repository where the actual Kubernetes manifests (Deployments, Services, Ingresses, etc.) for a specific application are stored. ArgoCD then continuously monitors these source repositories and ensures the live state in the Kubernetes cluster matches the declared state in Git.

## Directory Structure

Applications are organized logically within the `applications/` directory:

.
├── applications/
│   └── nginx-prometheus/
│       └── nginx-prometheus.yaml  # ArgoCD Application definition for the nginx-prometheus
├── README.md              # This file
└── .gitignore


* **`applications/`**: Root directory for all ArgoCD Application definitions.
* **`applications/nginx-prometheus/`**: Contains ArgoCD Application definitions related to the `nginx-prometheus` namespace or logical grouping.
* **`nginx-prometheus.yaml`**: The specific ArgoCD `Application` resource that tells ArgoCD how to deploy the WordPress application.

## Key Application: nginx-prometheus (WordPress)

This repository currently defines the ArgoCD `Application` for the `nginx-prometheus` WordPress instance.

* **Application Name:** `nginx-prometheus`
* **Target Kubernetes Namespace:** `nginx-prometheus` (This is where the WordPress pods, services, etc., will be deployed in the cluster)
* **Application Type:** WordPress (typically Nginx + PHP-FPM + MySQL/MariaDB)
* **ArgoCD Project:** `default` (or your custom ArgoCD project name)

### Source Code for `nginx-prometheus`

The actual Kubernetes manifests (Deployment, Service, Ingress, etc.) for the WordPress `nginx-prometheus` are **not** in this repository. They are located in a separate Git repository that ArgoCD monitors:

* **WordPress App Repository URL:** `https://github.com/your-org/your-wordpress-app-repo.git` (Please replace with your actual WordPress application's Git repository URL)
* **Path within Repo:** `k8s/wordpress` (Please replace with the actual path to your WordPress manifests within that repository)
* **Target Revision:** `HEAD` (or `main`, `v1.0.0`, etc. - the branch/tag ArgoCD monitors)

## Deployment Strategy

The `nginx-prometheus` ArgoCD Application is configured with an **Automated Sync Policy**. This means:

* **Continuous Monitoring:** ArgoCD constantly watches the WordPress application's source Git repository for changes.
* **Automated Sync:** Any detected changes are automatically applied to the Kubernetes cluster.
* **`prune: true`**: Resources that are removed from the Git repository will be automatically deleted from the cluster.
* **`selfHeal: true`**: If the live state of resources in the Kubernetes cluster drifts from the Git-defined state, ArgoCD will automatically revert them to match Git.
* **`CreateNamespace=true`**: The `nginx-prometheus` namespace will be automatically created in the target cluster if it doesn't already exist.

## How it Works

1.  **ArgoCD Application Definition:** The `nginx-prometheus.yaml` file in this repository defines the desired state for ArgoCD itself.
2.  **ArgoCD Discovery:** Your ArgoCD instance (running in the `argocd` namespace of your cluster) is configured to monitor *this* GitOps repository. It discovers the `nginx-prometheus.yaml` Application resource.
3.  **Application Synchronization:** Upon discovering the `nginx-prometheus` Application, ArgoCD then starts monitoring the specified `source.repoURL` (`https://github.com/manaspradhan007/argocd-release-repo.git`) and `source.path` (`k8s/wordpress`).
4.  **Automated Deployment:** ArgoCD compares the manifests in the WordPress app repository with the actual state in the `nginx-prometheus` namespace of your Kubernetes cluster. Any discrepancies trigger an automated synchronization, ensuring your WordPress application is always up-to-date.

## Prerequisites

To use this repository effectively:

* **Kubernetes Cluster:** A running Kubernetes cluster.
* **ArgoCD Installation:** ArgoCD must be installed and running in your Kubernetes cluster (e.g., in the `argocd` namespace).
* **Git Access:** ArgoCD needs network access to the `https://github.com/manaspradhan007/argocd-release-repo.git` repository.
* **`kubectl` CLI:** For interacting with your Kubernetes cluster.
* **`argocd` CLI:** For managing ArgoCD applications (optional, but useful for manual syncs, status checks).

## Getting Started

To deploy the ArgoCD `Application` defined in this repository:

1.  **Clone this GitOps repository:**
    ```bash
    git clone https://github.com/manaspradhan007/argocd-release-repo.git
    ```
2.  **Ensure `kubectl` & `helm` are configured** to connect to your target Kubernetes cluster.
3.  **Apply the ArgoCD Application manifest:**
    ```bash
    kubectl apply -f applications/nginx-prometheus/nginx-prometheus.yaml
    ```
    This command tells your Kubernetes cluster to create the ArgoCD `Application` resource. ArgoCD will then pick up this new resource and begin managing the WordPress application.

4.  **Monitor the deployment:**
    You can track the synchronization status of `nginx-prometheus` via the ArgoCD UI or CLI:
    ```bash
    argocd app list
    argocd app get nginx-prometheus
    ```

## Accessing Applications

Once ArgoCD has successfully synchronized the `nginx-prometheus` WordPress application, it will be accessible via its configured Kubernetes Ingress.

* **WordPress Application URL:** `http(s)://wordpress.task.de` (Replace with your actual WordPress Ingress URL)
* **ArgoCD UI URL:** `http(s)://argocd.task.de` (Replace with your actual ArgoCD Ingress URL)

## Contributing

Contributions are welcome! If you need to add new applications or modify existing ArgoCD Application definitions:

1.  Create a new branch for your changes.
2.  Add or modify the relevant `Application` YAML files under the `applications/` directory.
3.  Commit your changes and open a Pull Request.
4.  Once merged to the main branch, ArgoCD will automatically detect and deploy the changes.
