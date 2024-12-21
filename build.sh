# Stop Existing Containers
#docker ps -a -q --filter ancestor=simplewebimg

docker rm $(docker stop $(docker ps -a -q --filter ancestor=simplewebimg))
docker rmi $(docker images simplewebimg)

# docker rmi simplewebimg
# Once the Dockerfile is ready, build the Docker image using the following command:
docker build -t simplewebimg .

# After building the image, you can run the Docker container using:
docker run --name "simpleweb" -d -p 8080:80 simplewebimg 