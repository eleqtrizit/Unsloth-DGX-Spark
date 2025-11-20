# Unsloth Spark

Unsloth Spark is a Docker-based environment for running Unsloth, a library that enables faster LLM fine-tuning with minimal memory usage. This project combines the Unsloth Docker container's library of notebooks with NVIDIA's PyTorch container to provide an optimized environment for LLM fine-tuning with GPU acceleration.

I imagine this will not be needed if Unsloth creates their own native image.  As of today, 11/19/2025, that is not the case.

## Prerequisites

- DGX Spark or related 3rd party device

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/eleqtrizit/Unsloth-DGX-Spark.git
   cd unsloth_spark
   ```

2. Build the container:
   ```bash
   make pull # need to fetch Unsloth's container
   make build
   ```

3. Run the test script:
   ```bash
   make run
   ```

## Makefile Commands

The project includes a Makefile with the following commands:

- `make build` - Build the container
- `make build-no-cache` - Build the container without using cache
- `make run` - Run the container and go to bash.  See below on how to run the container manually for more options.
- `make jupyter` - Run the container and start Jupyter
- `make clean` - Remove the container image
- `make info` - Show image information
- `make pull` - Pull the base Unsloth container

## Manual Docker Commands

If you prefer to use Docker commands directly without the Makefile:

### Running the Container

This may be the most useful.  Start this from any directory and it mount the local files directory into the container under /workspace/work

```bash
docker run --gpus all --ulimit memlock=-1 -it --ulimit stack=67108864 -v $(pwd):/workspace/work --rm unsloth_spark
```

### Running JupyterLab

Also will mount the local directory into the container, before starting Jupyter.

```bash
docker run --gpus all --ulimit memlock=-1 -it --ulimit stack=67108864 --rm -p 7654:7654 -v $(pwd):/workspace/work unsloth_spark /workspace/start-jupyter.sh
```

## Features

- Based on NVIDIA's PyTorch container (25.09-py3) for GPU optimization
- Pre-installed JupyterLab for interactive development
- Volume mounting for persistent work data

## Example Usage

The `test_unsloth.py` script demonstrates how to:
1. Load a pre-quantized 4-bit model
2. Apply LoRA fine-tuning
3. Train on a dataset using SFTTrainer

## Updating the Container

Simply rebuild.  `make build`
