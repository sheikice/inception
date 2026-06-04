docker container stop wp
docker container rm wp
docker rmi wordpress:inception
docker build -t wordpress:inception .
docker run -d --network inception_network \
	--env-file ../../.env --name wp wordpress:inception
