# clang Repo seems to be not working right now
# FROM buildpack-deps:xenial
FROM sbx320/clang:svn

# Clang 4.0
#RUN apt-get update && apt-get install -y software-properties-common
#RUN add-apt-repository -s "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial main" && \
#  wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
  
#RUN apt-get update && apt-get install -y clang-4.0 && \
#  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
  
# Setup clang as default compiler
#ENV CC clang-4.0
#ENV CXX clang++-4.0
#RUN ln -s /usr/bin/clang-4.0 /bin/cc &&\
#  ln -s /usr/bin/clang++-4.0 /bin/cxx
  
# Boost
ARG boost_version=1.62.0
ARG boost_dir=boost_1_62_0

RUN wget http://downloads.sourceforge.net/project/boost/boost/${boost_version}/${boost_dir}.tar.gz \
    && tar xfz ${boost_dir}.tar.gz \
    && rm ${boost_dir}.tar.gz \
    && cd ${boost_dir} \
    && ./bootstrap.sh \
    && ./b2 --without-python -j 4 link=shared runtime-link=shared install \
    && cd .. && rm -rf ${boost_dir} 

# Premake5
RUN mkdir -p /tmp/premake \
  && git clone https://github.com/premake/premake-core.git /tmp/premake \
  && cd /tmp/premake \
  && make -f Bootstrap.mak linux \
  && ./bin/release/premake5 embed \
  && cp ./bin/release/premake5 /bin \
  && rm -rf /tmp/premake
  
