FROM nvidia/cudagl:11.1.1-devel-ubuntu20.04 

LABEL org.opencontainers.image.authors="yuzhong1214@gmail.com"

ARG USERNAME=user
ARG USER_UID=1005
ARG USER_GID=$USER_UID
ARG VGLUSERS_GID=1002

# Create the user
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    sudo \
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
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    curl \
    git \
    htop \
    net-tools \
    tmux \
    vim \
    wget \
    python3-pip \
    # For visualization
    libgtk2.0-dev \
    && rm -rf /var/lib/apt/lists/*

# Install conda
RUN curl -L -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && chmod +x ~/miniconda.sh \
    && ~/miniconda.sh -b -p /opt/conda \
    && rm ~/miniconda.sh \
    && /opt/conda/bin/conda install numpy pyyaml scipy ipython mkl mkl-include \
    && /opt/conda/bin/conda clean -ya
ENV PATH=/opt/conda/bin:$PATH

# Set the default user
USER $USERNAME
COPY .bashrc /home/$USERNAME/.bashrc
ENV PATH="/home/$USERNAME/.local/bin:${PATH}"
CMD ["/bin/bash"]

# Install custom environment
RUN git clone https://github.com/YuZhong-Chen/.setup_env.git ~/.setup_env \
    && cd ~/.setup_env && ./install.sh

# Create SG-Nav environment
RUN conda create -n SG_Nav python==3.9
RUN conda install -n SG_Nav -y habitat-sim==0.2.4 -c conda-forge -c aihabitat
RUN /bin/zsh -c "conda init zsh" \
    && echo "conda activate SG_Nav" >> ~/.zshrc

# Install habitat-lab
COPY --chown=$USERNAME:$USERNAME habitat-lab /home/$USERNAME/habitat-lab
RUN /bin/bash -c "source activate SG_Nav; \
    pip install -e /home/$USERNAME/habitat-lab"

# Install habitat dependencies
RUN sudo apt-get update && sudo apt-get install -y \
    libgl1-mesa-dev \
    libglib2.0-0 \
    && sudo rm -rf /var/lib/apt/lists/*

# Install faiss
RUN conda install -n SG_Nav -c pytorch -y faiss-gpu=1.8.0

# Install PyTorch
RUN /bin/bash -c "source activate SG_Nav; \
    pip3 install \
    torch==1.9.1+cu111 \
    torchvision==0.10.1+cu111 \
    -f https://download.pytorch.org/whl/torch_stable.html"

# Install SG-Nav dependencies
RUN /bin/bash -c "source activate SG_Nav; \
    pip3 install \
    transformers==4.30.0"
RUN /bin/bash -c "source activate SG_Nav; \
    pip3 install \
    pslpython==2.3.3 \
    yacs==0.1.8 \
    open3d \
    ollama \
    scikit-image \
    scikit-learn \
    scikit-fmm \
    pandas \
    omegaconf \
    nltk \
    inflect \
    einops \
    prettytable \
    ftfy"
RUN /bin/bash -c "source activate SG_Nav; \
    pip3 install git+https://github.com/facebookresearch/pytorch3d.git"

# Install segment-anything
COPY --chown=$USERNAME:$USERNAME segment_anything /home/$USERNAME/segment_anything
RUN /bin/bash -c "source activate SG_Nav; \
    pip3 install -e /home/$USERNAME/segment_anything"

# Install Ollama
RUN /bin/bash -c "source activate SG_Nav; \
    curl -fsSL https://ollama.com/install.sh | sh"