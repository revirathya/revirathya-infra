#!/usr/bin/env bash
set -uo pipefail

CRD_SCHEMAS='https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json'
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/kubeconform"
mkdir -p "$CACHE_DIR"

status=0

for k in $(find clusters -name kustomization.yaml); do
  dir=$(dirname "$k")
  echo "==> $dir"
  kubectl kustomize "$dir" | kubeconform -strict -summary \
    -cache "$CACHE_DIR" \
    -ignore-missing-schemas \
    -schema-location default \
    -schema-location "$CRD_SCHEMAS" \
    || status=1
done

exit $status
