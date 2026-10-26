.PHONY: init hooks-update pre-commit clean-cache \
	pg-show pg-apply pg-delete pg-forward \
	finance-show finance-apply finance-delete finance-forward


CACHE_DIR = $${XDG_CACHE_HOME:-$$HOME/.cache}/kubeconform
init:
	uv tool install pre-commit
	-git config --unset core.hooksPath
	pre-commit install

	curl -sL https://github.com/yannh/kubeconform/releases/latest/download/kubeconform-linux-amd64.tar.gz \
	| tar xz -C ~/.local/bin kubeconform
	mkdir -p "$(CACHE_DIR)"

hooks-update:
	pre-commit autoupdate

pre-commit:
	pre-commit run --all-files

clean-cache:
	rm -rf "$(CACHE_DIR)"

POSTGRES_CONFIG = clusters/kind-dev/postgres
pg-show:
	kubectl get all -n postgres

pg-apply:
	kubectl apply -k $(POSTGRES_CONFIG)

pg-delete:
	kubectl delete -k $(POSTGRES_CONFIG)

pg-forward:
	kubectl port-forward -n postgres svc/postgres-cluster-rw 6432:5432

FINANCE_CONFIG = clusters/kind-dev/finance
finance-show:
	kubectl get all -n finance

finance-apply:
	kubectl apply -k $(FINANCE_CONFIG)

finance-delete:
	kubectl delete -k $(FINANCE_CONFIG)

finance-forward:
	kubectl port-forward -n finance svc/core-service 10051:50051 10090:9090
