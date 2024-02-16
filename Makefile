COMPOSE = docker-compose -f ./docker-compose.yaml -f ./docker-compose-venom.yaml
VENOM_RESULTS = ./test_results
VENOM_VER := v1.2.0-beta.4
include .env .venom-env
export

env-up:
	@$(COMPOSE) up --force-recreate -d || { \
	  failed_services=""; \
	  for service in $$(eval $(COMPOSE) config --services); do \
	      $(COMPOSE) logs --tail=100 $$service; \
	      if $(COMPOSE) ps $$service | grep -q 'Up'; then \
	          exit_code=$$($(COMPOSE) ps -q $$service | xargs docker inspect -f '{{ .State.ExitCode }}'); \
	          if [ $$exit_code -ne 0 ]; then \
	              failed_services="$$failed_services $$service"; \
	          fi \
	      else \
	          failed_services="$$failed_services $$service (not running)"; \
	      fi \
	  done; \
	  if [ -n "$$failed_services" ]; then \
	      echo "Services that failed: $$failed_services"; \
	  fi; \
	  $(COMPOSE) ps -a; \
	exit 1; \
	}

env-down:
	@$(COMPOSE) down --volumes --remove-orphans

.PHONY: env-up env_down