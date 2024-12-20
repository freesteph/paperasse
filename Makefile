DOCKER-RUN = docker compose run -e TERM -e RUBY_DEBUG_NO_RELINE=true --rm --entrypoint=""
BUNDLE-EXEC = bundle exec

build:
	docker compose build

up:
	docker compose up

down:
	docker compose down

sh:
	$(DOCKER-RUN) web bash

lint:
	$(DOCKER-RUN) web $(BUNDLE-EXEC) rubocop

guard:
	$(DOCKER-RUN) web $(BUNDLE-EXEC) guard
