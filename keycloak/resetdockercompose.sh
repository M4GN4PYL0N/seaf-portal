#!/bin/bash

echo "reset docker compose"
docker-compose down
docker-compose down --volumes
docker-compose down --rmi all --volumes
echo "Done"
