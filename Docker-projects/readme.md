these projects are (Non-Commercial Use Only)
you can also find my dockerhub https://hub.docker.com/u/sampathsai

instructions to create and upload are below

# Navigate to the directory with the Dockerfiles and make sure src files are in same folder/directory as dockerfile
cd path/to/your/project

# Build the Docker image
docker build -t your-dockerhub-username/app:latest .

# Tag the Docker image (if needed)
docker tag app:latest your-dockerhub-username/app:latest

# Log in to Docker Hub
docker login

# Push the Docker image to Docker Hub
docker push your-dockerhub-username/app:latest
