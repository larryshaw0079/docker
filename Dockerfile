FROM registry.cn-hangzhou.aliyuncs.com/insis_hanzawa/docker_public:base

RUN apt-get update && apt-get install -y git vim build-essential

WORKDIR /root
RUN git clone https://github.com/perslev/U-Time
RUN pip3 install -U pip setuptools
RUN pip3 install tensorflow

ENV LC_ALL C
