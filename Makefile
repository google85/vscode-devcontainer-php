DOCKER_IMAGE_NAME=google85/vscode-devcontainer-php
DOCKER_IMAGE_TAG=8.1
DOCKER_IMAGE_FULL=${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}

help: ## View all make targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build the images
	docker build . -t ${DOCKER_IMAGE_FULL}

push: ## Push the builded image to the registry
	docker push ${DOCKER_IMAGE_FULL}
