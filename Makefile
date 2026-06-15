all: fclean up

up:
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

.PHONE: all up re ps logs stop fclean
