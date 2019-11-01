FROM ubuntu:18.04
SHELL ["/bin/bash", "-c"]

# general tools
RUN apt-get update
RUN apt-get install -y build-essential libtool g++ gcc vim\
    curl wget python git unzip sudo gdb python-pip tmux qemu

# create CTF user
RUN useradd -m ctf
RUN echo "ctf ALL=NOPASSWD: ALL" > /etc/sudoers
USER ctf

# install GEF
RUN wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh
RUN export LC_CTYPE=C.UTF-8

# install RR
WORKDIR /tools
RUN sudo chown ctf /tools/
RUN sudo apt-get install -y ccache cmake make g++-multilib gdb \
  pkg-config coreutils python3-pexpect manpages-dev \
  ninja-build capnproto libcapnp-dev
RUN git clone https://github.com/mozilla/rr.git
RUN mkdir obj
WORKDIR /tools/obj
RUN cmake ../rr
RUN make -j8
RUN sudo make install

# install DynamoRIO (required for b7)
# WORKDIR /tools
# RUN sudo apt-get install -y doxygen transfig imagemagick ghostscript zlib1g-dev
# RUN git clone https://github.com/DynamoRIO/dynamorio.git
# WORKDIR /tools/dynamorio
# RUN mkdir build
# WORKDIR /tools/dynamorio/build
# RUN cmake ..
# RUN make -j8

# install rust
WORKDIR /tools
RUN wget -q -O setup.sh https://sh.rustup.rs
RUN chmod +x setup.sh
RUN ./setup.sh -y

ENV PATH="/home/ctf/.cargo/bin:${PATH}"

# install b7
WORKDIR /tools
RUN git clone https://gitlab.com/b7-re/B7.git
WORKDIR /tools/B7
RUN git submodule init
RUN git submodule update
RUN cargo install --path .

# install common python packages
RUN pip install pwntools
RUN pip install z3
RUN pip install angr