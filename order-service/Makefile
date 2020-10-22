dockerfile = ./Dockerfile
server = gcr.io
registry = fabijanbajo
repository_prefix = webshop-
repository = ${repository_prefix}$(shell basename $(CURDIR))
commit_hash = $(shell git rev-parse --short HEAD)
tag = ${server}/${registry}/${repository}:${commit_hash}
run_port = 9001

up: build run

publish: build-nc push

build:
	docker build \
		-t ${tag} . \
		-f ${dockerfile}
build-nc:
	docker build \
		-t ${tag} . \
		-f ${dockerfile} \
		--no-cache
run:
	docker run \
		--name ${repository} ${tag} \
		-p ${run_port}:${run_port} \
		-it \
		--rm
push:
	docker push ${tag}
