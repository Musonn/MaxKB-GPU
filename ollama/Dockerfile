# Use the NVIDIA CUDA runtime image as the base
FROM nvidia/cuda:12.6.3-cudnn-runtime-ubuntu20.04

# Set the environment to avoid timezone prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Set working directory inside the container
WORKDIR /app

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    software-properties-common \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Expose the port if the Ollama service or model serves on a specific port
EXPOSE 5000

# Set the default command (modify this based on how you use Ollama)
CMD ["bash"]
