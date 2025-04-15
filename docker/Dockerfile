FROM ubuntu:22.04

LABEL org.opencontainers.image.authors="yuzhong1214@gmail.com"

ARG USERNAME=user
ARG USER_UID=1005
ARG USER_GID=$USER_UID
ARG VGLUSERS_GID=1002

# Create the user
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    sudo \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
ENV SHELL=/bin/bash

# Add user to vglusers group
# NOTE: Only needed on the server
RUN groupadd -g $VGLUSERS_GID vglusers \
    && usermod -aG $VGLUSERS_GID $USERNAME

# Install common tools
RUN apt-get update && apt-get install -y \
    curl \
    git \
    htop \
    net-tools \
    tmux \
    vim \
    wget \
    && rm -rf /var/lib/apt/lists/*

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME
COPY .bashrc /home/$USERNAME/.bashrc
ENV PATH="/home/$USERNAME/.local/bin:${PATH}"
CMD ["/bin/bash"]

# Install custom environment
RUN git clone https://github.com/YuZhong-Chen/.setup_env.git ~/.setup_env \
    && cd ~/.setup_env && ./install.sh
