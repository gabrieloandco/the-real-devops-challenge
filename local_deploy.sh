docker-compose up -d
docker exec mongo mongoimport -d restaurant -c restaurant -u mongouser -p mongopass  --authenticationDatabase admin --drop   --file /fixture/restaurant.json