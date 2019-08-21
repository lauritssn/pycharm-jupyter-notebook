# Use the latest image from Jupyter without Tensorflow as
# we will install Tensorflow with GPU support ourselves.
ARG BASE_CONTAINER=jupyter/scipy-notebook:latest
FROM $BASE_CONTAINER

# Run the following as the user root
USER root

# Install the OpenSSH server and configure it
RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

# Permit root login - this is a potential security risk and
# and perhaps not really needed.
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

# Start the SSH server
# RUN /usr/sbin/sshd -D &

# Install stuff for NVidia GPU (CUDA)
RUN apt-get install -y gnupg

# Change workdir to tmp
WORKDIR /tmp

# Add NVIDIA package repositories
ARG CUDA_FILE=cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
RUN wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/$CUDA_FILE
RUN dpkg -i $CUDA_FILE

RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
RUN apt-get update

ARG ML_REPO=nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
RUN wget -q http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/$ML_REPO
RUN apt install -y ./$ML_REPO
RUN apt-get update

# Install NVIDIA driver
RUN apt-get install -y --no-install-recommends nvidia-driver-418
# Reboot. Check that GPUs are visible using the command: nvidia-smi

# Install development and runtime libraries (~4GB)
RUN apt-get install -y --no-install-recommends \
    cuda-10-0 \
    libcudnn7=7.6.0.64-1+cuda10.0  \
    libcudnn7-dev=7.6.0.64-1+cuda10.0

# Install TensorRT. Requires that libcudnn7 is installed above.
RUN apt-get update
RUN apt-get install -y --no-install-recommends libnvinfer5=5.1.5-1+cuda10.0
RUN apt-get install -y --no-install-recommends libnvinfer-dev=5.1.5-1+cuda10.0

RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/extras/CUPTI/lib64
RUN export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
RUN export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}

# Install extra stuff
RUN apt-get install -y postgresql-client

# Change the user password for jovyan - this is for PyCharm to be able to SSH into the container.
ARG NB_PASS=12345
RUN echo "$NB_USER:$NB_PASS"
RUN echo "$NB_USER:$NB_PASS" | chpasswd

# Restart SSH service
RUN service ssh restart

# Run the following as the NB_USER user
USER $NB_USER

# Install Tensorflow with GPU support and Keras
RUN conda install --quiet --yes 'tensorflow-gpu=1.13*' 'keras=2.2*'

# What if the package I need isn't in Anaconda
# First - check conda-forge. Conda Forge is a community project to build all the things.
# There is a really good chance that the package you need is there, and can be installed
# by specifying the conda-forge channel in your conda command conda -c conda-forge install my_package.
# If that fails - you can use conda skeleton to generate a conda recipe from the pypi package.
# You'll also need to build and upload the package to your own repository, so this can be cumbersome.
# If building your own packages is too cumbersome, you can fallback on pip. I do this for exploratory
# work al the time. However I'd recommend getting proper conda packages built before you
# release to production. The reason is that the conda mechanisms for ensuring that your
# dependencies are all fully resolved before you go to deploy
# (using anaconda constructor, or conda env export) won't completely work on pip packages

# Install extra packages for Jupyter / Python
RUN conda install -c conda-forge --quiet --yes ipython-sql psycopg2 shap
# RUN yes w | pip install ipython-sql psycopg2 # Only use pip if conda-forge does not work
RUN conda clean --all -f -y

# Run the following as the user root
USER root

# Clean up the CUDA installation
RUN rm /tmp/$CUDA_FILE
RUN rm /tmp/$ML_REPO

# Fix permissions after conda install
RUN fix-permissions $CONDA_DIR
RUN fix-permissions /home/$NB_USER

# Change workdir back
WORKDIR $HOME

# Change user back to NB_USER to prevent running stuff as root
USER $NB_USER

