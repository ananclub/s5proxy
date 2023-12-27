#!/bin/bash
set -e
TAG=${1:-"latest"}
NAME=ss5uv
DOCKERREPO="ananclub"
rm -rf build
mkdir -p build && cd build
cmake .. && make

exit 0
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

