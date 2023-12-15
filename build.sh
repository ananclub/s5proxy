#!/bin/bash
set -e
TAG=${1:-"latest"}
NAME=uvss5
DOCKERREPO="ananclub"
mkdir -p build && cd build
cmake .. && make

cat > Dockerfile <<EOF
FROM ubuntu:22.04
ADD src/s5proxy /
ENTRYPOINT ["/s5proxy"]
EOF

docker build -t ${DOCKERREPO}/${NAME} .
if [[ "$TAG" != "latest" ]] ;then
        docker push ${DOCKERREPO}/${NAME}:latest
        docker tag  ${DOCKERREPO}/${NAME}:latest ${DOCKERREPO}/${NAME}:${TAG}
        docker push ${DOCKERREPO}/${NAME}:${TAG}
fi

rm -rf Dockerfile 

docker run --rm -ti --name test ${DOCKERREPO}/${NAME}:latest

