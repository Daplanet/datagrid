export RELEASE_VERSION		:= $(shell date +%s)
export DEFAULT_NETWORK		:= public
export DOMAINNAME		:= testnet.dapla.net
export CF_EMAIL		:= EDITME
export CF_API_KEY		:= DIDNTEDITME

NETWORKS		:= public internal
STACK_NAME		:= $(shell basename "$$(pwd)")

.DEFAULT_GOAL		:= all
.DEFAULT: all
.PHONY: all deploy network image clean

all: clean deploy

clean:
	@-docker stack rm $(STACK_NAME)

deploy: image network 
	@docker stack deploy -c docker-compose.yml $(STACK_NAME)

$(NETWORKS):
	@-docker network create -d overlay --scope swarm $@

network: $(NETWORKS)

image:
	@exit 0

scan:
	@docker image ls | awk '/ago/ { system("docker run --rm -v /var/run/docker.sock:/var/run/docker.sock oliviabarnett/actuary:latest $$3); }'

distclean: clean
	@docker system prune -af
