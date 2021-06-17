local_deploy:
	docker-compose up -d
	docker exec mongo mongoimport -d restaurant -c restaurant -u mongouser -p mongopass  --authenticationDatabase admin --drop   --file /fixture/restaurant.json

local_test:
	curl localhost:8080/api/v1/restaurant 