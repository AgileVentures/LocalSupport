#!/bin/bash
# This script is designed for Ubuntu 12.04
# Once you have forked and cloned the repo you can run this script to set it up
# cd LocalSupport and
# run with . <filename>.sh

# OPTIONS: Useful if you have to rerun the script after an error
# NOTE: Most things are ok to re-run except possibly DB create
#       Db seed tasks and DB peer authentication fix
#   no_checkout - Do not checkout the develop branch
#   no_bundle - Do not run bundle and selenium installs
#   no_peer_fix - Do not apply peer fix to postgre config 
#   no_db_create - Do not create database, useful if DB exists
#   no_db_seed - Do not run seeding command, useful if already seeded

# Show commands as they are executed, useful for debugging
# turned off in some areas to avoid logging other scripts
set -v

# Store current stdout and stderr in file descriptors 3 and 4
# If breaking out of script before complete, restart terminal
# to restore proper descriptors
exec 3>&1
exec 4>&2

# Capture all output and errors in config_log.txt for debugging
# in case of errors or failed installs due to network or other issues
exec > >(tee config_log.txt)
exec 2>&1

# Function for standard error message
function error {
  echo "ERROR: Failed to $1, please fix the issue"
  echo "       and run the script again"
  echo "NOTE: You can optionally skip completed sections with"
  echo "      arguments listed at the top of this file."
}

if [[ $@ != *no_checkout* ]]; then
  # git checkout develop
  git checkout develop || { error "checkout develop branch"; return 1; }
fi

# Run bundle install to get the gems
if [[ $@ != *no_bundle* ]]; then
  # This was added to fix a problem with the bundle install of debug 1.6.2
  gem install debugger

  bundle install --without production || { error "bundle install"; return 1; }
  selenium install || { error "install selenium"; return 1; }
fi

# Apply peer authentication fix
if [[ $@ != *no_peer_fix* ]]; then
  sudo sed -i 's/local[ ]*all[ ]*postgres[ ]*peer/local all postgres peer map=basic/' /etc/postgresql/9.1/main/pg_hba.conf || { error "apply peer fix part 1"; return 1; }
  sudo sed -i "$ a\basic $USER postgres" /etc/postgresql/9.1/main/pg_ident.conf || { error "apply peer fix part 2"; return 1; }
  # Restart postgresql to apply changes
  sudo /etc/init.d/postgresql restart
fi

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

# Restore stdout and stderr and close file descriptors 3 and 4
exec 1>&3 3>&-
exec 2>&4 4>&-

# turn off echo
set +v

# Display completion notice
echo "**** NOTICE ****"
echo "SETUP COMPLETE"
echo "You can now run rails s to start a local server."
echo "See db/seeds.rb for user info"
echo "You can run the following commands to test your setup."
echo "All tests should pass"
echo "bundle exec rake spec"
echo "bundle exec rake cucumber"
