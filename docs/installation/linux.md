Notes on Linux installation
===========================

In order to work on LocalSupport, please fork and clone the project.

If you need to setup your development environment then [gorails](https://gorails.com/setup/ubuntu/17.10) has an excellent walkthrough.

1. Install Ruby 2.5.1
1. Fork the http://github.com/AgileVentures/LocalSupport repo (fork button at top right of github web interface)
1. Clone the new forked repo onto your dev machine
1. `cd LocalSupport`
1. Install [GNU IDN Library](https://www.gnu.org/software/libidn/manual/html_node/Downloading-and-Installing.html) version 1.33
  You will need a few basic tools, such as ‘sh’, ‘make’ and ‘cc’.
  ```bash
  wget -q ftp://ftp.gnu.org/gnu/libidn/libidn-1.33.tar.gz
  tar xfz libidn-1.33.tar.gz
  cd libidn-1.33/
  ./configure
  ...
  make
  ...
  make install
  ...
  cd ../../
  rm libidn-1.33.tar.gz
  ```

  The `make install` command may need to be ran with sudo. for ex:
  ```bash
  sudo make install
  ```

1. Install postgreSQL - see [PostgreSQL install instructions below](issues.md#postgresql-install)



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
  *Note:*  You might encounter error with the creating the relevant schema. This is due to some configuration error with PostgreSql. Solution of interest can be found [(1) here](PostgreSQL-problems-in-Debian.md) and [(2) here](issues.md#peer-authentication-fails-for-user-postgres). You should first drop the cluster as mentioned in (1) and then configure the user access privileges in pg_hba.conf and username mapping in pg_ident.conf. One way to successfully configure the line `pg_hba.conf` from

  ```
  # TYPE  DATABASE       USER            ADDRESS                 METHOD
  local   all             all                                     peer
  ```
  to

  ```
  # TYPE  DATABASE       USER            ADDRESS                 METHOD
  local   all             all                                     trust
  ```

If you hit problems, review issues below, and ask us on Slack chat.

[Note that rvm can be extremely helpful for managing ruby versions.  [Installing rvm on Ubuntu](https://www.digitalocean.com/community/articles/how-to-install-ruby-on-rails-on-ubuntu-12-04-lts-precise-pangolin-with-rvm)]

Debian 7 users can follow these instructions to launch Xvfb as daemon : [Xvfb-on-Debian-7](https://github.com/AgileVentures/LocalSupport/wiki/Xvfb-on-Debian-7)

## Run locally
and then in principle you can run rails server and see that app running locally.

The db/seeds.rb task that you ran added some organizations and a test user that you can experiment with. Read that file for more information.

## Run tests

Also you should run the specs and cucumber features to make sure your installation is solid.

Before running the tests you should create a file named `config/application.yml` and add the following line:

```yaml
DOIT_HOST: 'http://api.qa2.do-it.org/v2'
```


For confidence, you shall prepare the test database first by running
`rake db:test:prepare`, then run tests using following commands:

    bundle exec rake spec
    bundle exec rake cucumber

and then when you start any BDD or TDD ensure autotest is running in the background:

    bundle exec rake autotest
