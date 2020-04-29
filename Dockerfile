FROM registry.cn-hangzhou.aliyuncs.com/insis_hanzawa/docker_public:base

RUN apt-get update && apt-get install -y git build-essential

WORKDIR /root
RUN git clone https://github.com/perslev/U-Time
RUN pip3 install -U pip
RUN pip3 install tensorflow
RUN cd /root/U-Time && pip3 install .
WORKDIR /root

ENV LC_ALL C
