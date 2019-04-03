#!/bin/bash

npm install -g bower
bower install
bundle exec rake db:create:all
bundle exec rake db:schema:load
# bundle exec rake db:migrate
# bundle exec rake db:migrate VERSION=0
# bundle exec rake db:migrate
bundle exec rake db:test:prepare