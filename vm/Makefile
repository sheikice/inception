all: up

up:
	@sed -i "s/ config.ssh.username/#config.ssh.username/" Vagrantfile
	@vagrant up

ssh:
	@sed -i "s/#config.ssh.username/ config.ssh.username/" Vagrantfile
	@vagrant ssh -- -Y
down:
	@vagrant halt

re: fclean up

fclean:
	@vagrant destroy -f

.PHONY: all up re down fclean ssh
