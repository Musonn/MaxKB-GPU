## Introduction

This project is designed to run **MaxKB** alongside **Ollama** with GPU support, using Docker containers. **MaxKB** will leverage a local large language model provided by Ollama, which operates within an NVIDIA CUDA-enabled Docker environment for fast inference.

---

## About MaxDB, Ollama, and NVIDIA CUDA Docker

### MaxDB

* [**MaxDB**](https://github.com/1Panel-dev/MaxKB) is a flexible knowledge base management system designed for handling structured and unstructured data.
* It supports integration with external AI models for advanced querying and data analysis.

### Ollama

* [**Ollama**](https://ollama.com/) is a service for hosting and running large language models (LLMs).
* It provides a REST API interface for querying models, making it suitable for applications requiring local inference.
* By running Ollama in a CUDA-enabled environment, it leverages GPU acceleration for faster model performance.

### NVIDIA CUDA Docker

* [**NVIDIA CUDA Docker**](https://hub.docker.com/r/nvidia/cuda) enables the use of GPUs within Docker containers.


## Prerequisites

- Ensure Docker is installed and properly configured on your system.

---

## Procedure

### Step 1: Create a Docker Network

Create a custom Docker network to enable communication between containers:

```bash
docker network create ollama-network
```

---

### Step 2: Pull the MaxDB Image

Download the MaxDB image from the repository:

```bash
docker pull cr2.fit2cloud.com/1panel/maxkb
```

---

### Step 3: Build the Ollama (CUDA) Docker Image

Navigate to the directory containing the `Dockerfile` for Ollama and build the image:

```bash
docker build -t ollama-cuda -f ./ollama/Dockerfile .
```

---

### Step 4: Run the Containers

#### 4.1 Run the MaxDB Container

Start the MaxDB container with the following command:

```bash
docker run -d \
  --name=maxkb \
  --restart=always \
  -p 8080:8080 \
  -v C:/maxkb:/var/lib/postgresql/data \
  -v C:/python-packages:/opt/maxkb/app/sandbox/python-packages \
  --network ollama-network \
  cr2.fit2cloud.com/1panel/maxkb
```

Change the locations of data and python package here.

#### 4.2 Run the Ollama (CUDA) Container

Start the Ollama container with GPU support:

```bash
docker run --gpus all \
  --name ollama-gpu \
  --network ollama-network \
  ollama-cuda
```

---

### Step 5: Run the ollama

In the terminal that runs ollama-gpu, execute

```
ollama serve
```

### Step 6: Configure the Model in the System

1. Open browser and enter http://localhost:8080
2. Login with default account and password. Account: admin Password:   MaxKB@123..
3. Go to **System Management** → **Model Settings** → **All Models**.
4. Click **Add Model**.
5. Configure the following settings:

- **Model Name**: Set any name for the model.
- **Model Type**: Select "Large Language Model."
- **Base Model**: Choose a model compatible with your GPU.
- **API URL**: Enter `http://ollama-gpu:11434`.
- **API Key**: Arbitary.

---

## Notes

- By default MaxDB create two directories (`C:/maxkb` and `C:/python-packages`) to store data on your host machine.
