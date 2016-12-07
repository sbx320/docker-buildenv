# Essentially a FROM buildpack-deps:zesty
FROM sbx320/buildpack-deps-zesty

# GCC 7 for modern libstdc++ and ccache
RUN add-apt-repository ppa:ubuntu-toolchain-r/test \
  && apt-get update \
  && apt-get install -y gcc-7 g++-7 ccache \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Clang 4.0... maybe at some point when repos work again
#RUN add-apt-repository -s "deb http://apt.llvm.org/wily/ llvm-toolchain-wily main" && \
#  wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - &&\
#  apt-get update && apt-get install -y clang-4.0 && \
#  apt-get clean && rm -rf /var/lib/apt/lists/* 
  
# Setup clang as default compiler
#ENV CC clang-4.0
#ENV CXX clang++-4.0
#RUN ln -s /usr/bin/clang-4.0 /bin/cc &&\
#  ln -s /usr/bin/clang++-4.0 /bin/cxx

ENV CC gcc-7
ENV CXX g++-7

# Boost
ARG boost_version=1.62.0
ARG boost_dir=boost_1_62_0

RUN wget http://downloads.sourceforge.net/project/boost/boost/${boost_version}/${boost_dir}.tar.gz \
    && tar xfz ${boost_dir}.tar.gz \
    && rm ${boost_dir}.tar.gz \
    && cd ${boost_dir} \
    && ./bootstrap.sh \
    && ./b2 --without-python -j 4 link=static runtime-link=shared install \
    && cd .. && rm -rf ${boost_dir} 

# Premake5
RUN mkdir -p /tmp/premake \
  && git clone https://github.com/premake/premake-core.git /tmp/premake \
  && cd /tmp/premake \
  && make -f Bootstrap.mak linux \
  && ./bin/release/premake5 embed \
  && cp ./bin/release/premake5 /bin \
  && rm -rf /tmp/premake
  
