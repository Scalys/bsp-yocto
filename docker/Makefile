IMAGE_NAME = trustbox-builder

build:
	@echo ":: Building $(IMAGE_NAME) image..."
	docker build -t $(IMAGE_NAME) \
	    --build-arg http_proxy=$(http_proxy) --build-arg https_proxy=$(https_proxy) --build-arg no_proxy=$(no_proxy) \
	    --build-arg UID="$(shell id -u)" --build-arg GID="$(shell id -g)"  --build-arg USER="$(USER)" \
	    --network host \
	    . ; \

clean:
	@echo ":: Cleaning containers..."
	@if [ -n "$(shell docker ps -a -q --filter ancestor=$(IMAGE_NAME))" ]; then \
	    docker rm -f $(shell docker ps -a -q --filter ancestor=$(IMAGE_NAME)); \
	fi
	@echo ":: Cleaning images..."
	@if [ -n "$(shell docker images -q $(IMAGE_NAME))" ]; then \
	    docker rmi $(IMAGE_NAME); \
	fi

