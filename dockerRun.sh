#!/bin/bash
docker rm -f alpine-nia || echo ""
docker run -it \
  --name alpine-nia \
  -e DISPLAY=host.docker.internal:0 \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ~/.Xauthority:/root/.Xauthority \
  -v $(pwd)/NIA2PC/Contents/X_NIA2:/tmp/X_NIA2 \
  -p 2222:22 \
  xp6qhg9fmuolztbd2ixwdbtd1/nia-alpine /tmp/X_NIA2/launcher.sh "Site of Impulse Initiation"



# ./NIA2PC/Contents/X_NIA2/nrm/1dend/1dend.nrm