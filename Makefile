
build-image:
	cd docker; make build


build:
	mvn clean install


REMOTE_HOST=192.168.32.217
REMOTE_REGISTRY_PORT=5000
TOKEN=$(shell date +'%y-%m-%d_%H-%M-%S')
deploy-images:
	echo "Taging images"
	docker tag thingsboard/gateway ${REMOTE_HOST}:${REMOTE_REGISTRY_PORT}/thingsboard/gateway:${TOKEN}
	echo "Pushing images to server"
	docker push ${REMOTE_HOST}:${REMOTE_REGISTRY_PORT}/thingsboard/gateway:${TOKEN}
	echo "Pulling images in remote server"
	sshpass -p Asc3nt10 ssh administrator@${REMOTE_HOST} docker pull localhost:${REMOTE_REGISTRY_PORT}/thingsboard/gateway:${TOKEN}
	echo "Tagging images in remote server"
	sshpass -p Asc3nt10 ssh administrator@${REMOTE_HOST} docker tag localhost:${REMOTE_REGISTRY_PORT}/thingsboard/gateway:${TOKEN} ascentiotech/tb-gateway:latest

build-and-deploy: build build-image deploy-images
