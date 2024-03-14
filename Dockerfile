# Start with an Ubuntu base image
#FROM nvidia/cuda:12.3.2-cudnn9-devel-ubuntu22.04
FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04
# Avoid prompts from apt during build
ARG DEBIAN_FRONTEND=noninteractive

# Install Python, pip, and other dependencies
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set Python 3.10 as the default python version
RUN ln -s /usr/bin/python3.10 /usr/bin/python

# Copy your requirements file into the container
COPY requirements.txt /tmp/

# Install Python dependencies
RUN pip install -r /tmp/requirements.txt && \
    pip install torch==1.12.0+cu113 torchvision==0.13.0+cu113 torchaudio==0.12.0 --extra-index-url https://download.pytorch.org/whl/cu113

# Download the backbone model
RUN mkdir -p /app/models && \
    wget -O /app/models/dino_resnet50_pretrain.pth https://dl.fbaipublicfiles.com/dino/dino_resnet50_pretrain/dino_resnet50_pretrain.pth

# Copy the rest of your project into the container
COPY . /app

# Set working directory
WORKDIR /app

# Compile CUDA operators (assuming CUDA is set up externally, if needed)
# RUN cd models/ops && sh ./make.sh

# The command to run your application, adapt as necessary
# CMD ["bash", "./run.sh"]

# For now, let's keep the container running so we can execute commands manually
CMD ["tail", "-f", "/dev/null"]


