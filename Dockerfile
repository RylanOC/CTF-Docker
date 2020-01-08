FROM ubuntu:18.04
SHELL ["/bin/bash", "-c"]

# general tools
RUN apt-get update
RUN apt-get install -y build-essential libtool g++ gcc vim\
    curl wget python git unzip sudo gdb python-pip python3-pip\ 
    tmux qemu clang ccache cmake make g++-multilib gdb pkg-config\
    coreutils python3-pexpect manpages-dev ninja-build capnproto\
    libcapnp-dev ruby-dev

# create CTF user
RUN useradd -m ctf
RUN echo "ctf ALL=NOPASSWD: ALL" > /etc/sudoers
USER ctf

# install RR
WORKDIR /tools
RUN sudo chown ctf /tools/
RUN git clone https://github.com/mozilla/rr.git
RUN mkdir obj
WORKDIR /tools/obj
RUN cmake ../rr
RUN make -j8
RUN sudo make install

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

# install useful python packages
WORKDIR /home/ctf
RUN python -m pip install --user pwntools
RUN python -m pip install --user angr

# install gef dependencies
RUN python3 -m pip install --user unicorn
RUN python3 -m pip install --user capstone
RUN python3 -m pip install --user ropper

# build keystone from source (packaged version has known issues)
RUN git clone https://github.com/keystone-engine/keystone.git
RUN mkdir keystone/build
WORKDIR /home/ctf/keystone/build
RUN ../make-share.sh
RUN sudo make install
USER root
RUN echo "include /usr/local/lib" >> /etc/ld.so.conf
USER ctf
RUN sudo ldconfig
WORKDIR /home/ctf/keystone/bindings/python
RUN sudo make install
RUN sudo make install3

# install GEF
RUN wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh
ENV LC_CTYPE=C.UTF-8

# install one_gadget
RUN sudo gem install one_gadget

# install binwalk
USER root
# TODO: JANK JANK JANK
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
USER ctf
RUN sudo apt-get install -y binwalk

WORKDIR /home/ctf

# install checksec
RUN git clone https://github.com/slimm609/checksec.sh.git
ENV PATH="/home/ctf/checksec.sh:${PATH}"