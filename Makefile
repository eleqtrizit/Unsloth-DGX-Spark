# Makefile for unsloth_spark container

# Container name
CONTAINER_NAME = unsloth_spark
IMAGE_NAME = unsloth_spark

# Default target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build            - Build the container"
	@echo "  build-no-cache   - Build the container without using cache"
	@echo "  run              - Run the container"
	@echo "  clean            - Remove the container image"
	@echo "  test             - Test the container with the test script"
	@echo "  shell            - Run bash shell in the container"
	@echo "  jupyter          - Run JupyterLab from the container"

# Pull Unsloth container
.PHONY: pull
pull:
	docker pull --platform linux/amd64 unsloth/unsloth:latest

# Build the container
.PHONY: build
build: 
	docker build -t $(IMAGE_NAME) .

# Build the container without using cache
.PHONY: build-no-cache
build-no-cache:
	docker build --no-cache -t $(IMAGE_NAME) .

# Run the container with default command (test script)
.PHONY: run
run:
	docker run --gpus all --ulimit memlock=-1 -it --ulimit stack=67108864 -v $$(pwd):/workspace/work --rm $(IMAGE_NAME)

# Run JupyterLab from the container
.PHONY: jupyter
jupyter:
	docker run --gpus all --ulimit memlock=-1 -it --ulimit stack=67108864 --rm -p 7654:7654 -v $$(pwd):/workspace/work $(IMAGE_NAME) /workspace/start-jupyter.sh

# Clean up - remove the container image
.PHONY: clean
clean:
	docker rmi $(IMAGE_NAME) || true

# Show image information
.PHONY: info
info:
	docker images $(IMAGE_NAME)
