FROM registry.cn-hangzhou.aliyuncs.com/insis_hanzawa/docker_public:base

RUN apt-get update && apt-get install -y git vim build-essential

WORKDIR /root
RUN git clone https://github.com/perslev/U-Time
RUN pip3 install -U pip setuptools
RUN pip3 install tensorflow
RUN pip3 install -r /root/U-Time/requirements.txt
RUN rm /root/U-Time/README.md
RUN echo '' > /root/U-Time/README.md
RUN pip3 install -e U-Time
RUN ut fetch --dataset sleep-EDF-153 --out_dir datasets/sleep-EDF-153

ENV LC_ALL C
