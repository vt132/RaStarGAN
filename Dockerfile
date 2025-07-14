FROM nvidia/cuda:12.0.1-devel-ubuntu22.04

# Set the working directory
WORKDIR /workspace

# System setup
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    git \
    wget \
    curl \
    ca-certificates \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
# Copy only requirements to leverage Docker cache

COPY ./requirements.txt ./requirements.txt
RUN ln -sf /usr/bin/python3 /usr/bin/python
RUN pip3 install --no-cache-dir --upgrade pip setuptools

# Install PyTorch with CUDA 12.1 support
RUN pip3 install --no-cache-dir torch==2.5.1+cu121 torchvision==0.20.1+cu121 torchaudio==2.5.1+cu121 --index-url https://download.pytorch.org/whl/cu121

RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy the rest of the application
COPY . .

# Default command to start an interactive bash session
CMD ["/bin/bash"]