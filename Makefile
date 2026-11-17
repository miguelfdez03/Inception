NAME         = inception
COMPOSE_FILE = ./srcs/docker-compose.yml
ENV_FILE     = /home/miguel-f/.env
DATA_DIR     = /home/miguel-f/data

# Terminal colors
CYAN         = \033[0;36m
GREEN        = \033[0;32m
YELLOW       = \033[0;33m
RED          = \033[0;31m
RESET        = \033[0m

all: up

up: create_dirs
	@echo "$(CYAN)>> Launching $(NAME) services...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) up -d --build
	@echo "$(GREEN)>> Containers up and running.$(RESET)"

create_dirs:
	@mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress

down:
	@echo "$(YELLOW)>> Stopping $(NAME) services...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) down

re: down up

clean: down
	@echo "$(RED)>> Cleaning unused Docker resources...$(RESET)"
	@docker system prune -f

fclean: down
	@echo "$(RED)>> Full purge: removing containers, images, volumes and data...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) down -v --rmi all
	@sudo rm -rf $(DATA_DIR)/mariadb/* $(DATA_DIR)/wordpress/*
	@docker system prune -af --volumes

status:
	@docker compose -f $(COMPOSE_FILE) ps

logs:
	@docker compose -f $(COMPOSE_FILE) logs -f

.PHONY: all up down re clean fclean status logs create_dirs
