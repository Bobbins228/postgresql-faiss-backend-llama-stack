NAMESPACE=faiss-postgres

deploy-all:
	oc apply -f postgres-pvc.yaml -n $(NAMESPACE)
	oc apply -f postgres-secret.yaml -n $(NAMESPACE)
	oc apply -f postgres-deployment.yaml -n $(NAMESPACE)
	oc apply -f postgres-service.yaml -n $(NAMESPACE)
	oc apply -f llama-stack-distribution.yaml -n $(NAMESPACE)

delete-all:
	oc delete -f postgres-secret.yaml -n $(NAMESPACE) || true
	oc delete -f postgres-deployment.yaml -n $(NAMESPACE) || true
	oc delete -f postgres-service.yaml -n $(NAMESPACE) || true
	oc delete -f postgres-pvc.yaml -n $(NAMESPACE) || true
	oc delete -f llama-stack-distribution.yaml -n $(NAMESPACE) || true
	