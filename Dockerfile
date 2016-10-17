# Use a base image that already has ruby and and bundler installed
# https://github.com/docker-library/ruby/blob/e89be7d60685ec51a193a358a8f3364b287aee3b/2.3/Dockerfile
FROM ruby:2.3

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Install apt-based dependencies required to run rails with javascript. As the
# Ruby image itself is based on a Debian image, we use apt-get to install those.
RUN apt-get update && \
    apt-get -y install qt5-default \
                       libqt5webkit5-dev \
                       gstreamer1.0-plugins-base \
                       gstreamer1.0-tools \
                       gstreamer1.0-x \
                       xvfb \
                       npm \
                       nodejs-legacy

# Use a javascript package manager to download another javascript package manager
RUN npm install bower -g --unsafe-perm

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install --jobs 20 --retry 5

# Copy the main application
COPY . /usr/src/app

# Install javascript dependencies in vendor/assets/bower_components
RUN bower install --allow-root

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
