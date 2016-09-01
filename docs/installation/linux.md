In order to work on LocalSupport, please fork and clone the project.

1. Install Ruby 2.3.0
1. Fork the http://github.com/AgileVentures/LocalSupport repo (fork button at top right of github web interface)
1. Clone the new forked repo onto your dev machine
1. `cd LocalSupport`
1. Install Qt webkit headers - see [capybara-webkit gem below](Installation#capybara-webkit-gem)  
1. Install postgreSQL - see [PostgreSQL install instructions below](Installation#postgresql-install)
1. Install X virtual frame buffer

    `sudo apt-get install xvfb`
1. `git checkout develop`
1. Run `bundle install` to get the gems
1. Run `npm install` to get the javascript dependencies
1. Run the following to get the database set up and import seed data (**Note:** `db:setup` is a custom task that invokes all required import and seeds. )

    ```ruby
    bundle exec rake db:create
    bundle exec rake db:migrate
    bundle exec rake db:setup
    ```

If you hit problems, review issues below, and ask us on Slack chat.

[Note that rvm can be extremely helpful for managing ruby versions.  [Installing rvm on Ubuntu](https://www.digitalocean.com/community/articles/how-to-install-ruby-on-rails-on-ubuntu-12-04-lts-precise-pangolin-with-rvm)]

Debian 7 users can follow these instructions to launch Xvfb as daemon : [[Xvfb-on-Debian-7]]

## Run locally
and then in principle you can run rails server and see that app running locally.

The db/seeds.rb task that you ran added some organizations and a test user that you can experiment with. Read that file for more information.

## Run tests

Also you should run the specs and cucumber features to make sure your installation is solid. For confidence, you shall prepare the test database first by running
`rake db:test:prepare`, then run tests using following commands:

    bundle exec rake spec
    bundle exec rake cucumber

and then when you start any BDD or TDD ensure autotest is running in the background:

    bundle exec rake autotest