# docker-kafka

## Build image

    docker build -t alessiofiore/kafka:0.0.1 
	
## Run container

    docker run -p 2181:2181 -p 9092:9092 --name kafka -d alessiofiore/kafka:0.0.1
	
## Connect 

    docker exec -it kafka /bin/bash
	
## See logs
    docker logs --follow kafka