###############################################################################################################
FROM nvidia/cuda@sha256:40db1c98b66e133f54197ba1a66312b9c29842635c8cba5ae66fb56ded695b7c

ENV HADOOP_VERSION=2.7.2
LABEL HADOOP_VERSION=2.7.2

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get -y update && \
    apt-get -y install python \
        python-pip \
        python-dev \
        python3 \
        python3-pip \
        python3-dev \
        python-yaml \
        python-six \
        build-essential \
        wget \
        curl \
        unzip \
        automake \
        openjdk-8-jdk \
        openssh-server \
        openssh-client \
        lsof \
        libcupti-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget -qO- http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | \
    tar xz -C /usr/local && \
    mv /usr/local/hadoop-${HADOOP_VERSION} /usr/local/hadoop

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    HADOOP_INSTALL=/usr/local/hadoop \
    NVIDIA_VISIBLE_DEVICES=all

ENV HADOOP_PREFIX=${HADOOP_INSTALL} \
    HADOOP_BIN_DIR=${HADOOP_INSTALL}/bin \
    HADOOP_SBIN_DIR=${HADOOP_INSTALL}/sbin \
    HADOOP_HDFS_HOME=${HADOOP_INSTALL} \
    HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_INSTALL}/lib/native \
    HADOOP_OPTS="-Djava.library.path=${HADOOP_INSTALL}/lib/native"

ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${HADOOP_BIN_DIR}:${HADOOP_SBIN_DIR} \
    LD_LIBRARY_PATH=/usr/local/cuda/extras/CUPTI/lib:/usr/local/cuda/extras/CUPTI/lib64:/usr/local/nvidia/lib:/usr/local/nvidia/lib64:/usr/local/cuda/lib64:/usr/local/cuda/targets/x86_64-linux/lib/stubs:${JAVA_HOME}/jre/lib/amd64/server

WORKDIR /root


###############################################################################################################
# Add symbol link for libcuda.so
RUN ln -s /usr/local/cuda/targets/x86_64-linux/lib/stubs/libcuda.so \
          /usr/local/cuda/targets/x86_64-linux/lib/stubs/libcuda.so.1

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get clean && \
    apt-get update -y && \
    apt-get install -y gcc make build-essential python-dev python-setuptools libboost-python-dev libboost-thread-dev libssl-dev wget curl vim libboost-all-dev --allow-unauthenticated

# Install libs
RUN pip3 install -U pip
RUN pip3 install tqdm numpy pandas matplotlib scikit-learn scipy seaborn numba

WORKDIR /root
RUN wget https://files.pythonhosted.org/packages/5e/3f/5658c38579b41866ba21ee1b5020b8225cec86fe717e4b1c5c972de0a33c/pycuda-2019.1.2.tar.gz
RUN tar -xzvf pycuda-2019.1.2.tar.gz
RUN cd pycuda-2019.1.2
RUN ./configure.py --python-exe=/usr/bin/python3 --cuda-root=/usr/local/cuda --cudadrv-lib-dir=/usr/lib/x86_64-linux-gnu --boost-inc-dir=/usr/include --boost-lib-dir=/usr/lib --boost-python-libname=boost_python-py35 --boost-thread-libname=boost_thread --no-use-shipped-boost
RUN make -j 16
RUN python3 setup.py install
RUN pip3 install .

ENV LC_ALL C
