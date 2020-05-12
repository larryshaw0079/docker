FROM registry.cn-hangzhou.aliyuncs.com/insis_hanzawa/docker_public:base

# Add symbol link for libcuda.so
# RUN ln -s /usr/local/cuda/targets/x86_64-linux/lib/stubs/libcuda.so \
#           /usr/local/cuda/targets/x86_64-linux/lib/stubs/libcuda.so.1

#RUN apt-get update
#RUN apt-get install python python3 --upgrade

RUN pip3 install -U pip

# Install pytorch
RUN pip3 install torch torchvision
RUN pip3 install "pillow<7"

# Install libs
RUN pip3 install tqdm numpy pandas matplotlib scikit-learn pymltoolkit scipy seaborn numba statsmodels dill pymongo click
RUN pip3 install wandb

ENV LC_ALL C
