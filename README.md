# Devops-platform

A personal DevOps portfolio project demonstrating Docker containerization, GitHub Actions CI automation, container image publishing, Kubernetes deployment, access control, and Terraform module practice in a local lab environment.

> **Project scope:** This is a personal learning and portfolio project, not commercial DevOps experience. Kubernetes was deployed to a local `k3s` cluster. Terraform S3 module practice used Floci, a local AWS-compatible environment; this is not evidence of deployment to real AWS.

## Project Goals

- Containerize a Flask application using Docker.
- Automate testing and Docker image builds with GitHub Actions.
- Publish container images to GitHub Container Registry (GHCR).
- Deploy the application to a local Kubernetes (`k3s`) cluster.
- Demonstrate health checks, resource controls, Ingress/TLS, and least-privilege RBAC.
- Practise reusable Terraform modules and safe resource refactoring.

## Technology Stack

| Area | Technologies |
|---|---|
| Application | Python, Flask, Gunicorn |
| Containers | Docker |
| CI/CD | GitHub Actions, pytest |
| Container Registry | GitHub Container Registry (GHCR) |
| Orchestration | Kubernetes (`k3s`), Deployments, ReplicaSets, Pods, Services |
| Networking | Traefik Ingress, HTTP/HTTPS, TLS |
| Configuration | ConfigMaps, `imagePullSecrets` |
| Reliability | Readiness/liveness probes, CPU and memory requests/limits |
| Access Control | ServiceAccounts, Roles, RoleBindings, Kubernetes RBAC |
| Infrastructure as Code | Terraform, modules, variables, outputs, lifecycle rules, `moved` block |
| Local Cloud-Compatible Practice | Floci |

## Architecture
```mermaid
flowchart TD
    DEV[Developer]
    REPO[GitHub Repository]

    subgraph CI [CI Pipeline]
        GHA[GitHub Actions]
        TEST [Run pytest]
        BUILD [Build Docker Image]
        REG [Publish Image to GHCR]

        GHA --> TEST
        TEST --> BUILD
        BUILD --> REG
    end

    subgraph K8S [Local Kubernetes - k3s]
        DEP [Deployment]
        POD [Application Pods]
        SVC [ClusterIP Service]
        ING [Traefik Ingress]
        TLS [HTTPS - Self-signed TLS]

        DEP --> POD
        POD --> SVC
        SVC --> ING
        ING --> TLS
    end

    DEV --> REPO
    REPO --> GHA
    REG --> DEP
    CLIENT [Client] --> TLS
```
This diagram shows the high-level project workflow. Refer to the actual workflow files for exact triggers, permissions, image tags, and deployment automation.

## Application

The Flask application is version `1.0.0` and listens on container port `8080`.

| Endpoint | Purpose |
|---|---|
| `/` | Application root |
| `/health` | Health check |
| `/ready` | Readiness check |
| `/info` | Application information |
| `/metrics` | Metrics endpoint |

The container uses Python 3.14 slim and Gunicorn.

## CI/CD

The GitHub Actions CI workflow is configured for pushes and pull requests targeting `main`. The confirmed CI tasks include running `pytest` and building a Docker image. Image publishing to GHCR has also been configured.

The repository workflow files are the source of truth for the exact triggers, permissions, image tags, and job steps.

### Run Tests Locally

From the repository root, with the project's Python test dependencies installed:

```bash
pytest
```

### Build the Docker Image

Run from the repository root:

```bash
docker build -f docker/Dockerfile -t devops-platform:ci-test .
```

The final `.` is the Docker build context: the repository root.

### Run the Container Locally

```bash
docker run --rm -p 8080:8080 devops-platform:ci-test
```

In another terminal, test the application:

```bash
curl http://localhost:8080/health
curl http://localhost:8080/ready
curl http://localhost:8080/info
```

These commands assume host port `8080` is available. Stop the foreground container with `Ctrl+C`.

## Kubernetes Deployment

The application has been deployed to a **local `k3s` cluster**.

The demonstrated configuration includes:

- A Deployment with two replicas in the verified project state.
- A ClusterIP Service mapping port `80` to container port `8080`.
- A Traefik Ingress for `devops-platform.local`.
- TLS using a self-signed certificate for local testing.
- A ConfigMap for application settings, including environment and version.
- An `imagePullSecret` for a private GHCR image.
- Readiness and liveness probes using `/ready` and `/health`.
- CPU and memory requests and limits.
- A dedicated deployment ServiceAccount with namespace-scoped RBAC.

The self-signed certificate is for lab use and is not publicly trusted. This is not a public production service.

### Verify a Deployment

Ensure `kubectl` targets the intended local cluster.

```bash
kubectl get deployments,pods,services,ingress
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl describe deployment devops-platform
kubectl rollout status deployment/devops-platform
```

Resource names may need to be adjusted if the manifests have changed. The hostname `devops-platform.local` requires appropriate local name resolution on the machine making the request.

## Security and Reliability

### Least-Privilege Access

A dedicated Kubernetes ServiceAccount and namespace-scoped RBAC are used for deployment rather than broad administrator permissions.

The goal is to restrict the actions available to the deployment identity and reduce the potential blast radius of a compromised credential.

Review the current Role and RoleBinding manifests before describing the exact permissions granted.

### Container Registry Credentials

The Kubernetes workload uses an `imagePullSecret` to authenticate to a private GHCR image.

Never commit registry tokens, credentials, private keys, or other secrets to Git.

### Health Checks and Resource Controls

Readiness and liveness probes help Kubernetes determine whether the application should receive traffic and whether a container needs restarting.

CPU and memory requests and limits make resource expectations explicit and help prevent uncontrolled resource consumption.

### Terraform State and Secrets

Do not commit credentials, access tokens, private keys, `.env` files, Terraform state files, or secret variable files.

Terraform state can contain infrastructure metadata and sensitive values. Real or team environments require an appropriate state-storage design, access control, encryption, and locking.

## Terraform Module Practice

Terraform practice focused on a reusable S3 bucket module, module inputs and outputs, lifecycle safeguards, and resource refactoring with a `moved` block.

The refactoring plan was verified as:

```text
Plan: 0 to add, 0 to change, 0 to destroy.
```

This demonstrated that the resource-address refactor in that exercise did not plan resource recreation.

> **Environment limitation:** this exercise used Floci as a local AWS-compatible environment. It does not prove that the same configuration has been deployed or validated in a real AWS account. Real AWS behaviour, IAM permissions, backend configuration, and service support require separate validation.

## Troubleshooting

### ImagePullBackOff

Check the image name and tag, registry visibility, and `imagePullSecret` credentials in the correct namespace.

### Pod Not Ready

Inspect pod events and logs. Verify probe paths, application startup, and the container port.

### Ingress or HTTPS Failure

Check the Ingress host rule, Traefik status, TLS secret, local name resolution, and Service routing.

### Unexpected Terraform Plan

Inspect configuration, state, and the real environment before applying. Review every planned creation, update, replacement, or deletion.

Useful Kubernetes diagnostic commands:

```bash
kubectl get pods
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl get events --sort-by=.metadata.creationTimestamp
```

Replace `<pod-name>` with the actual pod name. Never paste secret values into public issues or logs.

## Evidence and Validation

Useful evidence for reviewers includes:

- A successful GitHub Actions run showing tests and image build.
- Workflow YAML showing explicit permissions.
- The GHCR package/image corresponding to the documented version or tag.
- Kubernetes manifests for Deployment, Service, Ingress, probes, resource controls, and RBAC.
- Sanitized rollout output and successful health checks.
- Terraform configuration and plan output demonstrating the `moved`-block refactor.

Only add badges or screenshots that point to real, current results. Never include tokens, credentials, private keys, or sensitive account details.

## Known Limitations

- Kubernetes runs in a local `k3s` lab, not a managed production cluster.
- Local Ingress uses a self-signed TLS certificate.
- Monitoring components were tested in the constrained lab, but the monitoring stack was removed and is not presented as a continuously running service.
- AWS services and architecture have been studied; a real AWS deployment is not claimed.
- Floci is intended for local AWS-compatible practice and is not a substitute for validation in real AWS.
- This is a personal portfolio project, not commercial DevOps employment.

## Links

- **GitHub Profile:** https://github.com/grim-82
- **Project Repository:** https://github.com/grim-82/devops-platform

Keep this README aligned with the current source code, workflow files, Kubernetes manifests, test results, and actual lab state.
