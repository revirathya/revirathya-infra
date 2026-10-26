# NOTES ONLY. DON'T RUN

### Installation ###
helm install \
  cert-manager oci://quay.io/jetstack/charts/cert-manager \
  --version v1.21.2 \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true

### Database ###
kubectl create namespace database
kubectl apply -f clusters/kind-dev/database/cluster.yaml
kubectl get cluster -n database -w

### Image ###
kind load docker-image revirathya/revirathya-finance-core:0.1.0 --name dev
kind load docker-image revirathya/revirathya-finance-migration:0.1.0 --name dev   # you'll need this one too

### Ports ###
for n in $(kind get nodes --name dev); do echo "== $n"; docker port "$n"; done

### Traefik ###
helm repo add traefik https://traefik.github.io/charts
helm repo update

helm upgrade --install traefik traefik/traefik \
  --namespace traefik --create-namespace \
  -f clusters/kind-dev/traefik/values.yaml

kubectl get pods -n traefik # traefik-xxx  Running
kubectl get svc -n traefik  # 80:30080/TCP
kubectl get ingressclass    # traefik (default)

curl -X POST http://finance.localhost:30080/graphql \
  -H 'Content-Type: application/json' \
  -d '{"query":"{ __typename }"}'
