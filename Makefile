NAME=inception
FILE=srcs/docker-compose.yml


all:
	mkdir -p /home/${USER}/data/mariadb
	mkdir -p /home/${USER}/data/wordpress
	docker compose -f $(FILE) -p $(NAME) up -d --build

down:
	docker compose -f $(FILE) -p $(NAME) down

re: down all

clean: down
	docker rmi $(NAME)-mariadb $(NAME)-wordpress $(NAME)-nginx; \
	docker volume rm $(NAME)-mariadb $(NAME)-wordpress; \
	sudo rm -rf /home/${USER}/data/mariadb; \
	sudo rm -rf /home/${USER}/data/wordpress;

.PHONY: all re down clean
