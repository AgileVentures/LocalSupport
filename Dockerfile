FROM ruby:2.5.3
RUN apt-get update -qq && apt-get install -y build-essential \
    libpq-dev qt5-default libqt5webkit5-dev dos2unix \
    gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 9.5.0

RUN mkdir $NVM_DIR

# install nvm
# https://github.com/creationix/nvm#install-script
RUN curl --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash

# install node and npm
RUN echo "source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default" | bash

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN wget -q ftp://ftp.gnu.org/gnu/libidn/libidn-1.33.tar.gz
RUN tar xfz libidn-1.33.tar.gz
RUN cd libidn-1.33 && ./configure; make; make install;

RUN mkdir /LocalSupport
WORKDIR /LocalSupport

COPY Gemfile /LocalSupport/Gemfile
COPY Gemfile.lock /LocalSupport/Gemfile.lock
RUN bundle install

COPY package.json /LocalSupport/package.json
COPY package-lock.json /LocalSupport/package-lock.json
COPY bower.json /LocalSupport/bower.json
COPY check-version.js /LocalSupport/check-version.js
RUN npm install --unsafe-perm
RUN npm install -g phantomjs-prebuilt --unsafe-perm

COPY . /LocalSupport
