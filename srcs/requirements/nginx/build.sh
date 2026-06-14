docker container stop myproxy
docker container rm myproxy
docker rmi nginx:inception
docker build -t nginx:inception .
docker run -d --network inception_network \
	--env-file ../../.env --name myproxy nginx:inception
