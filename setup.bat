@echo off

:: Step 1: Create a Docker Network
echo Creating Docker network: ollama-network...
docker network create ollama-network
if %errorlevel% neq 0 (
    echo Failed to create Docker network. Exiting.
    exit /b %errorlevel%
)

:: Step 2: Pull the MaxDB Image
echo Pulling MaxDB image...
docker pull cr2.fit2cloud.com/1panel/maxkb
if %errorlevel% neq 0 (
    echo Failed to pull MaxDB image. Exiting.
    exit /b %errorlevel%
)

:: Step 3: Build the Ollama (CUDA) Docker Image
echo Building Ollama CUDA image...
docker build -t ollama-cuda -f ./ollama/Dockerfile .
if %errorlevel% neq 0 (
    echo Failed to build Ollama CUDA image. Exiting.
    exit /b %errorlevel%
)

:: Step 4.1: Run the MaxDB Container
echo Running MaxDB container...
docker run -d ^
  --name=maxkb ^
  --restart=always ^
  -p 8080:8080 ^
  -v C:/maxkb:/var/lib/postgresql/data ^
  -v C:/python-packages:/opt/maxkb/app/sandbox/python-packages ^
  --network ollama-network ^
  cr2.fit2cloud.com/1panel/maxkb
if %errorlevel% neq 0 (
    echo Failed to start MaxDB container. Exiting.
    exit /b %errorlevel%
)

:: Step 4.2: Run the Ollama (CUDA) Container
echo Running Ollama CUDA container...
docker run --gpus all ^
  --name ollama-gpu ^
  --network ollama-network ^
  ollama-cuda
if %errorlevel% neq 0 (
    echo Failed to start Ollama CUDA container. Exiting.
    exit /b %errorlevel%
)

:: Step 5: Start Ollama
echo To start Ollama, open the terminal running Ollama-GPU container and execute:
echo ollama s
echo Setup complete.
pause
