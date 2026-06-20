SECRETS_DIR="secrets"
SECRETS= mysql_password.txt mysql_root_password.txt wp_admin_password.txt wp_user_password.txt
all: fclean up

up: secrets
	@mkdir -p ~/data/wordpress ~/data/mariadb
	@docker compose --file srcs/docker-compose.yml up --build -d

re: fclean up

ps:
	@docker compose  --file srcs/docker-compose.yml ps

logs:
	@docker compose  --file srcs/docker-compose.yml logs

stop:
	@docker compose  --file srcs/docker-compose.yml stop


fclean:
	@docker compose --file srcs/docker-compose.yml down --rmi all -v

secrets:
	@mkdir -p $(SECRETS_DIR)
	@for secret in $(SECRETS); do \
		if [ ! -s $(SECRETS_DIR)/$$secret ]; then \
			openssl rand -base64 32 > $(SECRETS_DIR)/$$secret; \
		fi; \
	done

.PHONY: all up re ps logs stop fclean secrets
