FROM pai.build.base:hadoop2.7.2-cuda9.0-cudnn7-devel-ubuntu16.04
# Add symbol link for libcuda.so
RUN ln -s /usr/local/cuda/targets/x86_64-linux/lib/stubs/libcuda.so \
          /usr/local/cuda/targets/x86_64-linux/lib/stubs/libcuda.so.1

RUN apt-get clean && apt-get update && apt-get instal -y gcc make build-essential libssl-dev wget curl vim --allow-unauthenticated

WORKDIR /root
RUN wget http://zlib.net/zlib-1.2.11.tar.gz
RUN tar -xvf zlib-1.2.11.tar.gz
WORKDIR /root/zlib-1.2.11
RUN ./configure && make && make install

WORKDIR /root
RUN wget https://www.python.org/ftp/python/3.6.10/Python-3.6.10.tgz
RUN tar -xzvf Python-3.6.10.tgz
WORKDIR /root/Python-3.6.10

RUN ./configure && make && make install
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3 get-pip.py

RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple -U pip

# Install mxnet
RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple mxnet-cu90 gluonts mxboard

# Install libs
RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple tqdm numpy pandas matplotlib scikit-learn pymltoolkit scipy seaborn numba statsmodels dill pymongo click

ENV LC_ALL C
