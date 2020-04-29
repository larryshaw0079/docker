FROM registry.cn-hangzhou.aliyuncs.com/insis_hanzawa/docker_public:base

WORKDIR /root
RUN git clone https://github.com/perslev/U-Time
RUN pip3 install -U pip
RUN pip3 install tensorflow
RUN pip3 install -e U-Time

ENV LC_ALL C
