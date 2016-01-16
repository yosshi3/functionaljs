FROM phusion/baseimage:0.9.11
# c.f. https://github.com/phusion/baseimage-docker
MAINTAINER Akimichi Tatsukawa <akimichi.tatsukawa@gmail.com>
ENV REFRESHED_AT 2016-1-15(Fri)
## Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

ENV HOME /root
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

## apt-get update
RUN sed -i~ -e 's;http://archive.ubuntu.com/ubuntu;http://ftp.jaist.ac.jp/pub/Linux/ubuntu;' /etc/apt/sources.list
RUN apt-get -yqq update

## Japanese Environment
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y language-pack-ja
ENV LANG ja_JP.UTF-8
RUN update-locale LANG=ja_JP.UTF-8
RUN (mv /etc/localtime /etc/localtime.org && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime)

## Development Environment
ENV EDITOR vim
RUN update-alternatives --set editor /usr/bin/vim.basic
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git wget curl unzip build-essential python-dev rake

## node.js Environment
RUN add-apt-repository ppa:chris-lea/node.js
RUN apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs 

# Install nvm with node and npm
# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
WORKDIR /root
ENV NODE_VERSION 0.12.0
# setup the nvm environment
RUN git clone https://github.com/creationix/nvm.git $HOME/.nvm
RUN echo '#The Following loads nvm, and install Node.js which version is assigned to $NODE_ENV' >> $HOME/.profile
RUN echo 'source ~/.nvm/nvm.sh' >> $HOME/.profile
RUN echo 'echo "Installing node@${NODE_VERSION}, this may take several minutes..."' >> $HOME/.profile
RUN echo 'nvm install ${NODE_VERSION}' >> $HOME/.profile
RUN echo 'nvm alias default ${NODE_VERSION}' >> $HOME/.profile
RUN echo 'echo "Install node@${NODE_VERSION} finished."' >> $HOME/.profile
# RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.25.4/install.sh | bash \
#     && source $NVM_DIR/nvm.sh \
#     && nvm install $NODE_VERSION \
#     && nvm alias default $NODE_VERSION \
#     && nvm use default \
#   	&& npm install -g npm 
# ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
# ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

RUN npm install -g node-gyp &&\
    npm install -g mocha &&\
    npm install -g gulp &&\
    npm install -g coffee-script
# RUN echo 'alias gulp='node --harmony `which gulp`' >> $HOME/.profile
RUN mkdir nodejs
COPY .nvmrc gulpfile.js package.json nodejs/
COPY test nodejs/test
COPY succeeded nodejs/succeeded
COPY failed nodejs/failed

WORKDIR nodejs
# RUN nvm use
RUN npm install



## sbt


## haskell


RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ENTRYPOINT ["/bin/bash", "--login", "-i", "-c"]
# CMD ["bash"]

# CMD /bin/sh
CMD gulp js-test

