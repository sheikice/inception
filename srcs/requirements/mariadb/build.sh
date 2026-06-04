docker container stop mydb
docker container rm mydb
docker rmi mariadb:inception
docker build -t mariadb:inception .
docker run -d --network inception_network \
	--env-file ../../.env --name mydb mariadb:inception
