FROM alpine:latest

ENV USERNAME=morphs
ENV PYTHON_VERSION=3.9.19

RUN apk add --no-cache \
    sudo \
    bash \
    openssh \
    xauth \
    xorg-server \
    cmake \
    bison \
    flex \
    git \
    libx11-dev \
    libxcomposite-dev \
    openmpi \
    openmpi-dev \
    python3-dev \
    py3-pip \
    py3-scipy \
    py3-numpy \
    g++ \
    make \
    libffi-dev \
    openssl-dev \
    ncurses-dev \
    xz \
    tk \
    curl \
    llvm \
    zlib-dev \
    sqlite-dev \
    bzip2-dev \
    readline-dev \
    xz-dev \
    patch \
    mesa-demos \
    mesa-gl \
    mesa-dri-gallium

RUN adduser -D $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN echo "X11Forwarding yes" >> /etc/ssh/sshd_config && \
    echo "X11UseLocalhost no" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

USER $USERNAME
WORKDIR /home/$USERNAME

RUN git clone https://github.com/pyenv/pyenv.git /home/$USERNAME/.pyenv

RUN /home/$USERNAME/.pyenv/bin/pyenv install $PYTHON_VERSION && \
    /home/$USERNAME/.pyenv/bin/pyenv global $PYTHON_VERSION && \
    /home/$USERNAME/.pyenv/bin/pyenv rehash

ENV PATH=/home/$USERNAME/.pyenv/versions/$PYTHON_VERSION/bin/:$PATH
RUN /home/$USERNAME/.pyenv/versions/$PYTHON_VERSION/bin/python -m pip install cython

RUN git clone https://github.com/neuronsimulator/nrn && \
    cd nrn && \
    mkdir build output && \
    cd build && \
    cmake .. \
        -DNRN_ENABLE_INTERVIEWS=ON \
        -DNRN_ENABLE_MPI=OFF \
        -DNRN_ENABLE_RX3D=OFF \
        -DPYTHON_EXECUTABLE=/home/$USERNAME/.pyenv/versions/$PYTHON_VERSION/bin/python \
        -DCMAKE_INSTALL_PREFIX=/home/$USERNAME/nrn/output && \
    cmake --build . --parallel "$(nproc)" --target install

ENV PATH="/home/$USERNAME/nrn/output/x86_64/bin:$PATH"
EXPOSE 22

ENTRYPOINT ["/bin/bash"]