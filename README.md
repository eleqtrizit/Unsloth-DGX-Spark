# Unsloth Spark

Unsloth Spark is a Docker-based environment for running Unsloth, a library that enables 5X faster LLM fine-tuning with minimal memory usage. This project combines the Unsloth library with NVIDIA's PyTorch container to provide an optimized environment for LLM fine-tuning with GPU acceleration.

## Prerequisites

- Docker installed on your system
- NVIDIA GPU with CUDA support
- NVIDIA Container Toolkit installed
- At least 16GB RAM recommended

## Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/eleqtrizit/Unsloth-DGX-Spark
   cd unsloth_spark
   ```

2. Build the container:
   ```bash
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
- `make run` - Run the container with the default test script
- `make jupyter` - Run JupyterLab from the container
- `make clean` - Remove the container image
- `make info` - Show image information
- `make pull` - Pull the base Unsloth container

## Manual Docker Commands

If you prefer to use Docker commands directly without the Makefile:

### Building the Container
```bash
docker build -t unsloth_spark .
```

### Running the Container
```bash
docker run --gpus all --ulimit memlock=-1 -it --ulimit stack=67108864 -v $(pwd):/workspace/work --rm unsloth_spark
```

### Running JupyterLab
```bash
docker run --gpus all --ulimit memlock=-1 -it --ulimit stack=67108864 --rm -p 7654:7654 -v $(pwd):/workspace/work unsloth_spark /workspace/start-jupyter.sh
```

### Running a Shell in the Container
```bash
docker run --gpus all --ulimit memlock=-1 -it --ulimit stack=67108864 -v $(pwd):/workspace/work --rm unsloth_spark /bin/bash
```

## Project Structure

- `Dockerfile` - Defines the container with Unsloth and NVIDIA PyTorch
- `Makefile` - Contains common commands for building and running
- `test_unsloth.py` - Example script demonstrating Unsloth usage
- `start-jupyter.sh` - Script to start JupyterLab (created during build)

## Features

- Based on NVIDIA's PyTorch container (25.09-py3) for GPU optimization
- Includes Unsloth library for 5X faster LLM fine-tuning
- Pre-installed JupyterLab for interactive development
- Configured for GPU acceleration with proper memory limits
- Volume mounting for persistent work data

## Example Usage

The `test_unsloth.py` script demonstrates how to:
1. Load a pre-quantized 4-bit model
2. Apply LoRA fine-tuning
3. Train on a dataset using SFTTrainer

To run this example:
```bash
make run
```

Or manually:
```bash
docker run --gpus all --ulimit memlock=-1 -it --ulimit stack=67108864 -v $(pwd):/workspace/work --rm unsloth_spark python /workspace/work/test_unsloth.py
```

## JupyterLab Access

To use JupyterLab:
```bash
make jupyter
```

Then open your browser to `http://localhost:7654`

To secure JupyterLab with a password, set the `JUPYTER_PASSWORD` environment variable:
```bash
JUPYTER_PASSWORD=yourpassword make jupyter
```

## Customization

To use a different model, modify the `test_unsloth.py` script and change the model name in:
```python
model, tokenizer = FastModel.from_pretrained(
    model_name = "unsloth/gemma-3-4B-it",  # Change this line
    # ... other parameters
)
```

Refer to the [Unsloth HuggingFace page](https://huggingface.co/unsloth) for a list of supported models.