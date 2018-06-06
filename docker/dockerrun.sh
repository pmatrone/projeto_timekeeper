# Run Containers

echo "Starting container"
docker run --name postgres-timekeeper -d -p 5432:5432 postgres/timekeeper

docker ps | grep timekeeper