FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Set up locale
RUN apt-get update && \
    apt-get install -y locales && \
    locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    export LANG=en_US.UTF-8

# Install necessary tools
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    wget \
    git \
    build-essential \
    software-properties-common \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Add ROS 2 Jazzy repository and key
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2-testing/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) main" | tee /etc/apt/sources.list.d/ros2-testing.list > /dev/null

    RUN apt-get update && apt-get install -y \
    ros-jazzy-desktop \
    python3-colcon-common-extensions \
    python3-rosdep \
    && rm -rf /var/lib/apt/lists/*

# Install Gazebo Harmonic
RUN wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null && \
    apt-get update && \
    apt-get install -y gz-harmonic && \
    rm -rf /var/lib/apt/lists/*

# Source ROS 2 setup on shell startup
RUN echo "source /opt/ros/jazzy/setup.bash" >> /root/.bashrc

# Initialize rosdep after ROS 2 installation
RUN rosdep init && \
    rosdep update

# Set environment variables for GUI and runtime
ENV QT_X11_NO_MITSHM=1
ENV DISPLAY=:0
ENV XDG_RUNTIME_DIR=/tmp/runtime-dir
ENV NVIDIA_DRIVER_CAPABILITIES=all,graphics
ENV NVIDIA_VISIBLE_DEVICES=all

# Create runtime directory
RUN mkdir -p /tmp/runtime-dir && \
    chmod 700 /tmp/runtime-dir

# Install additional dependencies for GUI and NVIDIA
RUN apt-get update && apt-get install -y \
    x11-apps \
    mesa-utils \
    libgl1 \
    libegl1 \
    libglx0 \
    libglvnd0 \
    && rm -rf /var/lib/apt/lists/*

# NVIDIA Container Toolkit support
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all

CMD ["/bin/bash"]