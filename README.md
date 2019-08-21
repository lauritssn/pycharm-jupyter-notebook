# How to run a Jupyter Notebook in PyCharm with Tensorflow GPU support.

How to run a Jupyter Notebook in PyCharm with remote interpreter support (run the Jupyter Notebook on a remote computer with GPU support).

## Prerequisites

* A remote computer with for instance Ubuntu a GPU (like RTX 2080 Ti) and Docker version 19 or later as this has native GPU support.
* A "local" computer with PyCharm version 2019.02 or later (as the Jupyter support was completely rewritten in this version).

## How to run it

The Dockerfile uses a standard Jupyter Notebook image as base image. This image is Ubuntu based. An ssh server is installed on top for remote access and port 2222 on the host is mapped to port 22 inside the container to prevent conflicts with the ssh server of the host.

Finally GPU drivers from NVidia are manually installed in the image.

## PyCharm configuration

PyCharm has some nice installation instructions here:

Please note that xxxxx.


## Build the Docker image

cd into the Github folder where you cloned the repository

Run this command that will build the image as my_image

docker build -t my_image .





