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

```bash
docker build -t my_image .
```



## References
* https://docs.nvidia.com/cuda/cuda-installation-guide-linux/
* https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1804&target_type=deblocal
* https://marmelab.com/blog/2018/03/21/using-nvidia-gpu-within-docker-container.html
* https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1804&target_type=runfilelocal
* https://gist.github.com/zhanwenchen/e520767a409325d9961072f666815bb8#install-nvidia-graphics-driver-via-apt-get
* https://gist.github.com/dte/8954e405590a360614dcc6acdb7baa74
* https://github.com/jupyterhub/zero-to-jupyterhub-k8s/issues/994 # TENSORFLOW-GPU
* https://www.tensorflow.org/install/gpu
* https://medium.com/data-science-bootcamp/anaconda-miniconda-cheatsheet-for-data-scientists-2c1be12f56db
* https://heartbeat.fritz.ai/top-7-libraries-and-packages-of-the-year-for-data-science-and-ai-python-r-6b7cca2bf000
* https://jakevdp.github.io/blog/2017/12/05/installing-python-packages-from-jupyter/
* https://medium.com/@balaprasannav2009/install-tensorflow-pytorch-in-ubuntu-18-04-lts-with-cuda-9-0-for-nvidia-1080-ti-9e45eca99573

# Jupyter Notebook Help
* Make text ITALIC: *Italic*
* Make text BOLD: **Bold**
* List item as a bullet: dash and space -
* List item as a number: Simple as number and dot 1.
* Indenting text: Greater than and space >
* Inline code span: Back quotation mark " ` "
* Block of code: Triple back quotation marks " ``` "
* Link a section: [Title of Section](#title-of-section)
* Hyperlink: [Text](URL)



