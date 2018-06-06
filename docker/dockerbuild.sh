# Build Image Container

echo "Building Image"
cd postgres; docker build -t postgres/timekeeper .; cd ..

docker images | grep timekeeper