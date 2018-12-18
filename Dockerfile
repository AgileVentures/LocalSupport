FROM ruby:2.5
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential \
    libpq-dev nodejs qt5-default libqt5webkit5-dev dos2unix \
    gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

RUN wget -q ftp://ftp.gnu.org/gnu/libidn/libidn-1.33.tar.gz && tar xfz libidn-1.33.tar.gz && \
cd libidn-1.33 && ./configure; make; make install;

RUN mkdir /LocalSupport
WORKDIR /LocalSupport

COPY Gemfile Gemfile.lock /LocalSupport/
RUN bundle install

COPY package.json package-lock.json bower.json \
     check-version.js scripts/import_opportunities.sh /LocalSupport/
RUN npm install --unsafe-perm
RUN npm install -g phantomjs-prebuilt --unsafe-perm

COPY . /LocalSupport
