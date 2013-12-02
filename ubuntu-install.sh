#1. Install Ruby 1.9.3-p448 (we haven't migrated to Ruby 2 yet)

#2. Fork the http://github.com/tansaku/LocalSupport repo (fork button at top right of github web interface)

#3. Clone the new forked repo onto your dev machine

#4. cd LocalSupport

#5. Install Qt webkit headers - see capybara-webkit gem below

#6. Install postgreSQL - see PostgreSQL install instructions below

#7. Install X virtual frame buffer

#8. sudo apt-get install xvfb

#9. git pull origin develop

#10. git checkout develop

#11. Run bundle install to get the gems

#12. Run the following to get the database set up and import seed data