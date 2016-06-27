tag := 0.15.0.0_alpha
registry := melan/

build:
	docker build -t ${registry}pocketmine:${tag} .

push:
	docker push ${registry}pocketmine:${tag}

run:
	test -d players || mkdir players 
	test -d worlds || mkdir worlds
	docker run -it --rm -p 19132:19132/udp \
		-v `pwd`/players:/opt/pocketmine/PocketMine-MP/players \
		-v `pwd`/worlds:/opt/pocketmine/PocketMine-MP/worlds \
		${registry}pocketmine:${tag}