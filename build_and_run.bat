@echo off
SETLOCAL

REM --- Configuration ---
SET IMAGE_NAME=stargan-dev
SET CONTAINER_NAME=stargan-container

REM --- Get the directory of this script (your project root) ---
SET PROJECT_DIR=%~dp0

REM --- Create local directories for data and checkpoints if they don't exist ---
IF NOT EXIST "%PROJECT_DIR%data" (
    echo Creating 'data' directory...
    mkdir "%PROJECT_DIR%data"
)
IF NOT EXIST "%PROJECT_DIR%expr" (
    echo Creating 'expr' directory...
    mkdir "%PROJECT_DIR%expr"
)

REM --- Build the Docker image ---
echo Building Docker image: %IMAGE_NAME%...
docker build -t %IMAGE_NAME% .
IF %ERRORLEVEL% NEQ 0 (
    echo Docker build failed.
    exit /b %ERRORLEVEL%
)

REM --- Run the Docker container ---
echo Starting container %CONTAINER_NAME% in interactive mode...
echo Your project directory is mounted at /workspace
echo Exposing port 6006 for TensorBoard

docker run -it --rm ^
    --gpus all ^
    --name %CONTAINER_NAME% ^
    -v "%PROJECT_DIR%:/workspace" ^
    -p 6006:6006 ^
    %IMAGE_NAME%

ENDLOCAL