NAME=inception
FILE=srcs/docker-compose.yml


all:
	mkdir -p /home/${USER}/data/mariadb
	mkdir -p /home/${USER}/data/php
	docker compose -f $(FILE) -p $(NAME) up -d --build

down:
	docker compose -f $(FILE) -p $(NAME) down

re: down all

clean: down
	docker rmi $(NAME)-mariadb $(NAME)-php $(NAME)-nginx; \
	docker volume rm $(NAME)-mariadb $(NAME)-php; \
	sudo rm -rf /home/${USER}/data/mariadb; \
	sudo rm -rf /home/${USER}/data/php;

.PHONY: all re down clean
