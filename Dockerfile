FROM nvidia/cuda:10.1-cudnn7-devel

LABEL maintainer="support@sebit.world"

ENV GIT_REPO=https://github.com/AlexeyAB/darknet.git
ENV GIT_BRANCH=darknet_yolo_v3_optimal
ENV PRETRAINED_WEIGHT=https://pjreddie.com/media/files/darknet53.conv.74

ENV WORK_DIR=/usr/workspace
ENV OPENCV_VER=3.4.8
ENV CMAKE_VER=3.15.5
ENV PYTHON_VER=3.7
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda-10.1/lib64
ENV LIBRARY_PATH=${LIBRARY_PATH}:/usr/local/cuda-10.1/lib64
ENV PATH=${PATH}:/usr/local/cuda-10.1/bin


WORKDIR ${WORK_DIR}
# Install some convenient tool
RUN apt-get update && apt-get install -y software-properties-common wget

# Install Git
RUN apt-get install -y git

# Clone and checkout darknet v3 to current folder
RUN git clone ${GIT_REPO} --branch ${GIT_BRANCH} ${WORK_DIR}/darknet

# Install Python ${PYTHON_VER}
RUN add-apt-repository ppa:deadsnakes/ppa && apt-get install -y python${PYTHON_VER} python3-pip python3-dev
RUN ln -s /usr/bin/python${PYTHON_VER} /usr/bin/python
RUN python -m pip install --upgrade pip

# Install CMake ${CMAKE_VER}
RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VER}/cmake-${CMAKE_VER}.tar.gz
RUN tar -xvzf cmake-${CMAKE_VER}.tar.gz
WORKDIR ${WORK_DIR}/cmake-${CMAKE_VER}
RUN sh ./bootstrap && make -j4 && make install
WORKDIR ${WORK_DIR}

# Install Opencv ${OPENCV_VER}
RUN pip install numpy opencv-python
RUN apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev libgtk-3-dev libopencv-highgui-dev
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VER}.tar.gz
RUN tar -xvzf ${OPENCV_VER}.tar.gz
WORKDIR ${WORK_DIR}/opencv-${OPENCV_VER}/build
RUN cmake ../
RUN make -j4 && make install
WORKDIR ${WORK_DIR}

# Compile the project
WORKDIR ${WORK_DIR}/darknet
COPY . .
RUN make clean
RUN make -j8

# Project Specific Package
WORKDIR ${WORK_DIR}
RUN apt-get install vim -y
RUN pip install click pandas Pillow

# Download Pretrained Weight
RUN wget ${PRETRAINED_WEIGHT}

WORKDIR ${WORK_DIR}
CMD [ ]
