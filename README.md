# Postgres SQL Backend for Inline FAISS Vector_IO Provider

## Deployment Configuration

### Postgres Deployment

- **postgres-secret.yaml** - Kubernetes Secret containing PostgreSQL database credentials (database name, user, and password) used by the postgres deployment and Llama Stack.

- **postgres-pvc.yaml** - PersistentVolumeClaim requesting 20Gi of storage for PostgreSQL data persistence. Uses ReadWriteOnce access mode. *Note: It would be more effective to use ReadWriteMany (RWX) access mode for scenarios requiring shared access, but the current configuration uses ReadWriteOnce (RWO).*

- **postgres-service.yaml** - Kubernetes Service exposing the PostgreSQL database on port 5432 with NodePort type for cluster access.

- **postgres-deployment.yaml** - Deployment configuration for the PostgreSQL 15 container, including environment variables from the secret and volume mounts for persistent storage.

### Llama Stack Distribution

- **llama-stack-distribution.yaml** - Custom resource definition for LlamaStackDistribution that configures the Llama Stack server with FAISS enabled and PostgreSQL as the vector store backend. Includes resource limits, inference model configuration, and database connection settings. The distribution uses the `rh-dev` distribution and exposes the server on port 8321.

## Setup

To deploy the PostgreSQL backend, persistent storage (PVC), and the Llama Stack Distribution, start by creating a Kubernetes secret containing your inference model configuration in the `faiss-postgres` namespace. Replace the environment variables with your actual values as needed:

```bash
oc create secret generic llama-stack-inference-model-secret \
  --from-literal=INFERENCE_MODEL="$INFERENCE_MODEL" \
  --from-literal=VLLM_URL="$VLLM_URL" \
  --from-literal=VLLM_TLS_VERIFY="$VLLM_TLS_VERIFY" \
  --from-literal=VLLM_API_TOKEN="$VLLM_API_TOKEN" \
  -n faiss-postgres
```

Once the secret is in place, deploy all required resources using the Makefile (which uses the `faiss-postgres` namespace by default):

```bash
make deploy-all
```

## Removal
To remove all of the deployments, run:
```bash
make delete-all
```
You should also remove the inference model secret:
```bash
oc delete secret llama-stack-inference-model-secret -n faiss-postgres || true
```