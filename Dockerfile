FROM --platform=linux/amd64 unsloth/unsloth AS unsloth-source

FROM --platform=linux/arm64 nvcr.io/nvidia/pytorch:25.09-py3

# Install uv
RUN pip install uv

# Create virtual environment and install packages
ENV PATH="/opt/venv/bin:$PATH"

# Install JupyterLab and IPython
RUN pip install jupyterlab ipython

# Install required packages with uv pip
RUN pip install transformers peft "datasets==4.3.0" "trl==0.19.1"
RUN pip install --no-deps unsloth unsloth_zoo
RUN pip install hf_transfer
RUN pip install --no-deps bitsandbytes

# Copy workspace files from unsloth container
COPY --from=unsloth-source /workspace /workspace
RUN rm -rf /workspace/docker-examples

# Set proper permissions
RUN chmod -R a+rwx /workspace

# Expose ports
EXPOSE 8888 22


# Start script for JupyterLab
RUN mkdir -p /workspace && \
    echo '#!/bin/bash' > /workspace/start-jupyter.sh && \
    echo 'set -e' >> /workspace/start-jupyter.sh && \
    echo '' >> /workspace/start-jupyter.sh && \
    echo 'if [ ! -z "$JUPYTER_PASSWORD" ]; then' >> /workspace/start-jupyter.sh && \
    echo '    HASHED_PASSWORD=$(python -c "from jupyter_server.auth import passwd; print(passwd(\"$JUPYTER_PASSWORD\"))")' >> /workspace/start-jupyter.sh && \
    echo '    mkdir -p /root/.jupyter' >> /workspace/start-jupyter.sh && \
    echo '    echo "c.NotebookApp.password = '\''$HASHED_PASSWORD'\''" > /root/.jupyter/jupyter_notebook_config.py' >> /workspace/start-jupyter.sh && \
    echo '    echo "c.ServerApp.password = '\''$HASHED_PASSWORD'\''" > /root/.jupyter/jupyter_server_config.py' >> /workspace/start-jupyter.sh && \
    echo 'fi' >> /workspace/start-jupyter.sh && \
    echo '' >> /workspace/start-jupyter.sh && \
    echo 'mkdir -p /workspace/work' >> /workspace/start-jupyter.sh && \
    echo 'cd /workspace' >> /workspace/start-jupyter.sh && \
    echo 'exec jupyter lab --ip=0.0.0.0 --port=7654 --allow-root --no-browser --ServerApp.token="" --ServerApp.password=""' >> /workspace/start-jupyter.sh && \
    chmod +x /workspace/start-jupyter.sh

# Use CMD for default behavior, allowing easy override
# When no command is provided, run the test script
# When bash is requested, run bash
# When start-jupyter.sh is requested, run Jupyter
CMD ["/bin/bash"]
