dockerfile = ./Dockerfile
server = gcr.io
registry = fabijanbajo
repository_prefix = webshop-
repository = ${repository_prefix}$(shell basename $(CURDIR))
commit_hash = $(shell git rev-parse --short HEAD)
tag = ${server}/${registry}/${repository}:${commit_hash}
run_port = 3000

up: build run

build:
	docker build . \
		-t ${tag} \
		-f ${dockerfile}

run:
	docker run \
		--name ${repository} \
		--publish ${run_port}:${run_port} \
		--env SERVER_PORT=3000 \
		--env SERVER_HOST=0.0.0.0 \
		${tag} \
		--interactive \
		--tty

