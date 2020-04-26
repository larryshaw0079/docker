FROM registry.cn-hangzhou.aliyuncs.com/insis_hanzawa/docker_public:base

RUN pip3 install cython tqdm numpy pandas matplotlib scikit-learn scipy seaborn numba==0.29.0 llvmlite==0.15.0

WORKDIR /root
RUN wget https://files.pythonhosted.org/packages/5e/3f/5658c38579b41866ba21ee1b5020b8225cec86fe717e4b1c5c972de0a33c/pycuda-2019.1.2.tar.gz
RUN tar -xzvf pycuda-2019.1.2.tar.gz
RUN cd pycuda-2019.1.2
RUN ./configure.py --python-exe=/usr/bin/python3 --cuda-root=/usr/local/cuda --cudadrv-lib-dir=/usr/lib/x86_64-linux-gnu --boost-inc-dir=/usr/include --boost-lib-dir=/usr/lib --boost-python-libname=boost_python-py35 --boost-thread-libname=boost_thread --no-use-shipped-boost
RUN make -j 16
RUN python3 setup.py install
RUN pip3 install .

ENV LC_ALL C
