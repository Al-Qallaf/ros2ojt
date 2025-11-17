# ROS2 OJT Docker Environment

This repository provides a Dockerfile for building a ROS 2 Jazzy, including Gazebo Harmonic and NVIDIA GPU support.

## Features

- **Ubuntu 24.04 Base**
- **ROS 2 Jazzy (testing)**
- **Gazebo Harmonic**
- **NVIDIA GPU Support**
- **GUI Application Support**

---

## Prerequisites

Before building and running the Docker container, ensure you have the following installed on your system:

- [Docker Engine](https://docs.docker.com/engine/install/) (version 20.10 or newer recommended)
- [NVIDIA GPU drivers](https://www.nvidia.com/Download/index.aspx) (if using GPU features)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) (for GPU support)
- X11 server running (for GUI applications)
- Linux OS (tested on Ubuntu)

---

## Building the Docker Image

Clone this repository and navigate to the directory containing the Dockerfile:

```sh
git clone https://github.com/Al-Qallaf/ros2ojt.git
cd ros2ojt
docker build -t ros2ojt:latest .
```

---

## Running the Docker Container

To run the container with GUI and NVIDIA GPU support:

```sh
docker run -it --rm \
    --gpus all \
    -e DISPLAY=$DISPLAY \
    -e QT_X11_NO_MITSHM=1 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    ros2ojt:latest
```

- `-it`: Interactive terminal
- `--rm`: Remove container after exit
- `--gpus all`: Enable NVIDIA GPU support (requires [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html))
- `-e DISPLAY=$DISPLAY` and `-v /tmp/.X11-unix:/tmp/.X11-unix`: Enable GUI applications

**If you encounter X11 errors, run:**
```sh
xhost +local:docker
```

---