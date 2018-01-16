#!/bin/bash
# This script is designed for Ubuntu 12.04
# Once you have forked and cloned this repo you can run this script to set it up
# cd LocalSupport and
# run with . <filename>.sh

# OPTIONS: Useful if you have to rerun the script after an error
# NOTE: Most things are ok to re-run except possibly DB create
#       Db seed tasks and DB peer authentication fix
#   no_rvm_ruby - Do not try to update RVM and Ruby
#   no_package - Do not install aditional packages
#   no_bundle - Do not run bundle and selenium installs
#   no_peer_fix - Do not apply peer fix to postgre config
#   no_db_create - Do not create database, useful if DB exists
#   no_db_seed - Do not run seeding command, useful if already seeded

# Function for standard error message
function error {
  echo "ERROR: Failed to $1, please fix the issue"
  echo "       and run the script again"
  echo "NOTE: You can optionally skip completed sections with"
  echo "      arguments listed at the top of this file."
}

# Update RVM and Ruby
if [[ $@ != *no_rvm_ruby* ]]; then
  echo Y | rvm get stable || { error "update RVM"; return 1; }
  rvm reload || error "reload RVM first time"
  echo Y | rvm upgrade 1.9.3 || { error "upgrade Ruby"; return 1; }
  rvm reload || error "reload RVM second time"
fi

# Install needed packages
if [[ $@ != *no_package* ]]; then
  # Install Qt webkit headers
  sudo apt-get install -y libqtwebkit-dev || { error "install webkit dev"; return 1; }

  # Install postgreSQL
  sudo apt-get install -y libpq-dev || { error "install pg dev"; return 1; }
  sudo apt-get install -y postgresql || { error "install pg"; return 1; }

  # Install X virtual frame buffer
  sudo apt-get install -y xvfb || { error "install xvfb"; return 1; }

  # Remove un-needed packages
  sudo apt-get -y autoremove
fi

# git checkout develop
git checkout develop || { error "checkout develop branch"; return 1; }

# Run bundle install to get the gems
if [[ $@ != *no_bundle* ]]; then
  bundle install || { error "bundle install"; return 1; }
  selenium install || { error "install selenium"; return 1; }
fi

# Apply peer authentication fix, assumes saasbook username
# Change below if necessary and commit change before running script
if [[ $@ != no_peer_fix ]]; then
  sudo sed -i 's/local[ ]*all[ ]*postgres[ ]*peer/local all postgres peer map=basic/' /etc/postgresql/9.1/main/pg_hba.conf || { error "apply peer fix part 1"; return 1; }
  sudo sed -i '$ a\basic saasbook postgres' /etc/postgresql/9.1/main/pg_ident.conf || { error "apply peer fix part 2"; return 1; }
fi

# Restart postgresql to apply changes
sudo /etc/init.d/postgresql restart

# Run the following to get the database set up and import seed data
if [[ $@ != *no_db_create* ]]; then
  bundle exec rake db:create || { error "create DB"; return 1; }
fi
bundle exec rake db:migrate || { error "migrate DB"; return 1; }
if [[ $@ != *no_db_seed* ]]; then
  echo "Please wait, seeding database, this could take a while ..."
  bundle exec rake db:categories || { error "add categories to DB"; return 1; }
  bundle exec rake db:seed || { error "seed DB"; return 1; }
  bundle exec rake db:cat_org_import || { error "add org to DB"; return 1; }
  bundle exec rake db:pages || { error "add pages to DB"; return 1; }
  bundle exec rake db:import:emails[db/emails.csv] || { error "add emails to DB"; return 1; }
fi

# Prepare test database
bundle exec rake db:test:prepare

# Display completion notice
echo "**** NOTICE ****"
echo "SETUP COMPLETE"
echo "You can now run rails s to start a local server."
echo "See db/seeds.rb for user info"
echo "You can run the following commands to test your setup."
echo "All tests should pass"
echo "bundle exec rake spec"
echo "bundle exec rake cucumber"
