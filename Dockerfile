FROM ruby:2.5
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential \
    libpq-dev nodejs qt5-default libqt5webkit5-dev dos2unix \
    gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

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
