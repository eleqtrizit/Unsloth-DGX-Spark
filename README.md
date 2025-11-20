# Unsloth for DGX Spark

Unsloth Spark is a Docker-based environment for running Unsloth, a library that enables faster LLM fine-tuning with minimal memory usage. 

This project take's NVIDIA's PyTorch container, upgrades a few libs per Unsloth's Dockerfile, then tries to emulate Unsloth's own `unsloth/unsloth` container by cloning in their notebooks and installing Jupyter.

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
   make build
   ```

3. Login to container bash:
   ```bash
   make run
   ```
4. Test (after `make run`)!
   ```bash
   cd work && python test_unsloth.py
```

## Makefile Commands

The project includes a Makefile with the following commands:

```sh
> make
Available targets:
  build            - Build the container
  build-no-cache   - Build the container without using cache
  run              - Run bash from the container
  clean            - Remove the container image
  jupyter          - Run JupyterLab from the container
```

## Manual Docker Commands

Read the Makefile for example commands.  Ask an LLM what the params mean if you're unsure.

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
