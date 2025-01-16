# Neurons in Action in Docker Alpine

- https://neuronsinaction.com/neuron
- https://github.com/neuronsimulator/nrn
	- https://github.com/neuronsimulator/nrn/blob/master/docs/install/install_instructions.md

### Windows

- https://mobaxterm.mobatek.net/download.html

```
docker run -it `
  -e DISPLAY=host.docker.internal:0 `
  -v "$PWD\X_NIA2:/tmp/X_NIA2" `
  xp6qhg9fmuolztbd2ixwdbtd1/nia-alpine /tmp/X_NIA2/launcher.sh "Site of Impulse Initiation"
```

### Mac OSX

- https://www.xquartz.org

```
xhost + 127.0.0.1 && \
export DISPLAY=:0
```

```
#!/bin/bash
docker rm -f alpine-nia || echo ""
docker run -it \
  --name alpine-nia \
  -e DISPLAY=host.docker.internal:0 \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ~/.Xauthority:/root/.Xauthority \
  -v $(pwd)/X_NIA2:/tmp/X_NIA2 \
  -p 2222:22 \
  xp6qhg9fmuolztbd2ixwdbtd1/nia-alpine /tmp/X_NIA2/launcher.sh "Site of Impulse Initiation"
```