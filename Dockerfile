# Essentially a FROM buildpack-deps:zesty
FROM ubuntu:zesty

RUN apt-get update && apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		wget \
	&& rm -rf /var/lib/apt/lists/*
  
RUN apt-get update && apt-get install -y --no-install-recommends \
		bzr \
		git \
		mercurial \
		openssh-client \
		subversion \
		\
		procps \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
		autoconf \
		automake \
		bzip2 \
		file \
		g++ \
		gcc \
		imagemagick \
		libbz2-dev \
		libc6-dev \
		libcurl4-openssl-dev \
		libdb-dev \
		libevent-dev \
		libffi-dev \
		libgdbm-dev \
		libgeoip-dev \
		libglib2.0-dev \
		libjpeg-dev \
		libkrb5-dev \
		liblzma-dev \
		libmagickcore-dev \
		libmagickwand-dev \
		libmysqlclient-dev \
		libncurses-dev \
		libpng-dev \
		libpq-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		libtool \
		libwebp-dev \
		libxml2-dev \
		libxslt-dev \
		libyaml-dev \
		make \
		patch \
		xz-utils \
		zlib1g-dev \
	&& rm -rf /var/lib/apt/lists/*
 
# GCC 7 (mainly for a modern libstdc++ with c++17)
RUN add-apt-repository ppa:ubuntu-toolchain-r/test \
  && apt-get update \
  && apt-get install -y gcc-7 \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
 
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
  
