## Issues

### Heroku 
See [the notes on deploying to heroku](https://github.com/AgileVentures/LocalSupport/wiki/Deploying-to-Heroku)

### PostgreSQL Install

####Linux
```
sudo apt-get install libpq-dev
```
####OSX

Install the pg gem. You’ll need to include the following options to set your path and include the needed headers:
```
gem install pg -v 0.18.0 -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/9.4/bin/pg_config --with-pg-include='/Applications/Postgres.app/Contents/Versions/9.4/include/'
```
**Note: before you run this, check that the paths for `pg_config` and `include` are correct, and adjust them as needed. Example: If your application is named Postgres93, then “Postgres.app” will need to be changed to “Postgres93.app” in both places.**

install: [http://postgresapp.com/](http://postgresapp.com/)

We recommend installing: [http://postgresapp.com/](http://postgresapp.com/)

1. First error is usually "role 'postgres' does not exist (PG::ConnectionBad)"

2. Resolve this by running ```CREATE USER postgres CREATEDB;``` from the psql prompt (click the elephant icon and select "open psql" OR ```createuser -s -r postgres``` from command line if you have psql in your path

3. [Read this](https://www.digitalocean.com/community/tutorials/how-to-use-roles-and-manage-grant-permissions-in-postgresql-on-a-vps--2) for more helpful hints on how to fine-tune DB permissions.

Another error occurs on OSX without "host: localhost" in the database.yml
`could not connect to server: No such file or directory
 Is the server running locally and accepting
 connections on Unix domain socket "/var/pgsql_socket/.s.PGSQL.5432"?`

Postgres may have put its socket in an unexpected place, such as `/private/tmp`, and it may be a hidden file. In this example below, we symlink it to where it needs to be.
````
sudo mkdir /var/pgsql_socket/ 
sudo ln -s /private/tmp/.s.PGSQL.5432 /var/pgsql_socket/ 
````

if psql doesn't run from the command line try: add ```export PATH="/usr/local/bin:$PATH"``` to your ```.bash_profile```
to make sure you are talking to the postgres.app that's installed rather than the non-running postgresql that comes with OSX

OSX no longer needs host: localhost in database.yml if you ```export PG_HOST=localhost``` in ```.bash_profile```

####Could not connect to server: No such file or directory
```
could not connect to server: No such file or directory
	Is the server running locally and accepting
	connections on Unix domain socket "/var/run/postgresql/.s.PGSQL.5432"?
```

If you receive this error run
```
sudo apt-get install postgresql
```

####Peer authentication fails for user postgres

On Ubuntu, you will likely encounter an error with the following message:

`authentication failed for user "postgres"`

The underlying problem is that postgres is set up to authenticate postgresql usernames based on the Linux usernames.  But your Linux user is not likely called "postgres" like the yml configuration is setup to login as on LS.  

If you search around, you will likely find links telling you to change authentication methods and use a password.  But you can actually stick with peer authentication and the little bit of added security of only having local connections by doing the following:

You must edit the pg_hba.conf file to use a map with peer authentication (more on this here[http://www.postgresql.org/docs/9.1/static/auth-username-maps.html]).  The location of this file may vary depending on your installation but may be under `/etc/postgresql/9.1/main/pg_hba.conf` (where 9.1 depends on your version).  You should change the line in the file that reads as follows:

`local   all             postgres                             peer`


You want to edit it to be :

`local   all             postgres                                peer map=basic`


This will use a map called basic that you will set up next (you can change the name of the map as long as you change it in the next step as well).

Now you want to edit the file pg_ident.conf (same directory as the previous file) to include the following line:
`basic         saasbook                postgres`

This will map your Linux system name (in my example saasbook if you're using the VM) to the name expected by postgres.

You now need to restart the postgre service so that it takes to the new configuration.  In the terminal run this command:

`sudo /etc/init.d/postgresql restart`

Now you should be able to locally authenticate with postgres and no password.

Alternatively, if you are not too concerned with security, you can just change the authentication type to trust:

```
# Database administrative login by Unix domain socket
local   all   postgres      trust

# TYPE  DATABASE        USER            ADDRESS                 METHOD
# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 md5
```
this will allow any local connection to the database to be established without a password.

### Illformed requirement issue

You will likely encounter this error:

     Installing rdoc (3.12.2) Invalid gemspec in [/usr/local/lib/ruby/gems/1.9.1/specifications/ZenTest-4.9.0.gemspec]: Illformed requirement ["< 2.1, >= 1.8"]

Resolution described here: [http://stackoverflow.com/questions/15006181/zentest-errors-preventing-autotest-from-running/15006306#15006306](http://stackoverflow.com/questions/15006181/zentest-errors-preventing-autotest-from-running/15006306#15006306)  Also mentioned here with alternate solution [https://github.com/seattlerb/zentest/issues/40](https://github.com/seattlerb/zentest/issues/40) NOTE: stable fix appears to involve: "upgrade rubygems, uninstall zentest and reinstall zentest." (If you don't want to edit the gemspec file, you will need rubygems version 1.8.24 or later.) 

If you use rvm, then the command to upgrade rubygems is

    rvm rubygems current

### Invalid gemspec issue

One issue that someone has encountered is as follows:

I cloned the latest code on the github repo and running bundle install --without production seems to barf with many invalid gemspecs pointing to the 1.9.1 ruby installation
 seems I had to revert back to rubygem 1.8.24
 And to get tests to pass, I had to run it via rake spec, which required editing gemfile to include 'rails-rspec' under :test, :development

As is suggested by starfry's comment on stackoverflow [http://stackoverflow.com/questions/12159402/should-i-use-rake-spec-or-rspec-cant-get-rake-spec-to-work ](http://stackoverflow.com/questions/12159402/should-i-use-rake-spec-or-rspec-cant-get-rake-spec-to-work )         

 ... it seems to use development db when you run via spec

As per the documentation for [rspec-rails](https://www.relishapp.com/rspec/rspec-rails/docs),
  > It needs to be in the :development group to expose generators and rake tasks without having to type RAILS_ENV=test.

### Lack of JS runtime

Another issue that has been encountered is the following:

lack of JS runtime when running rake db:create' to the project 'LocalSupport'.

The following stackoverflow link contains the solution which is to add the execjs and therubyracer gems to the Gemfile, although we are not yet clear why this error sometimes crops up ...

[http://stackoverflow.com/questions/9057475/rake-dbcreate-could-not-find-a-javascript-runtime](http://stackoverflow.com/questions/9057475/rake-dbcreate-could-not-find-a-javascript-runtime)

### capybara-webkit gem

The `capybara-webkit` gem needs the Qt toolchain (including qmake and the webkit library and header files). You want version 4.8 or later. To install them in Ubuntu release 12.04 LTS "precise pangolin", or later, run: 

     sudo apt-get install libqtwebkit-dev

This command also works on Debian 7.

If you have an older version of Ubuntu, you can install a new version from scratch, or upgrade with `sudo do-release-upgrade`.  If on Amazon EC2, see (this article)[http://gregrickaby.com/safely-update-an-ubuntu-ec2-instance-on-amazon-aws/]

For other platforms, see http://qt-project.org/downloads. 

Note that on Mac, even after performing the aforementioned install, you are likely to need to install something else to get the `qmake` build tool. Install [Homebrew](http://brew.sh/), if you don't have it already, then run `brew install qt`. Then you should be able to run `gem install capybara-webkit -v '1.6.0'` successfully.

After that try running `bundle install` again. 

### An error occurred while installing nokogiri

May also say 'the compiler failed to generate an executable file. (RuntimeError) You have to install development tools first.'

There are various solutions for this online, but most recently the following worked on OSX Mountain Lion

```sh
bundle config build.nokogiri --use-system-libraries
bundle update nokogiri
```

### Warning: Nokogiri was built against LibXML version 2.8.0, but has dynamically loaded 2.9.0

You will likely encounter this warning while running the specs and features.
To solve this you need to run 

     bundle exec gem pristine nokogiri

What this basically does is that it recompiles the gem's C extensions. While running this, if you face the error
     ... you dont have write permissions ...

Run the command with sudo

    sudo bundle exec gem pristine nokogiri

### Postgres encoding does not match locale

If, when you try to create database tables, you see errors like this

    PG::InvalidParameterValue: ERROR:  encoding UTF8 does not match locale en_GB

our notes on [[PostgreSQL problems in Debian]] may help you.

### No source for ruby-1.9. ...

In 2014, David came across this error when running ```bundle install``` (under rvm on Debian)
 
    No source for ruby-1.9.3-p545 provided with debugger-ruby_core_source gem.
    ...
    Make sure that `gem install debugger -v '1.6.1'` succeeds before bundling.

The fix seems to be simply to run

```
gem install debugger
bundle install
```

and repeat for any other gems that stop your bundle install task.

=======

## Sam's ubuntu install notes from EC2

     sudo apt-get install ruby-dev
     sudo apt-get install libpq-dev
     sudo apt-get install libicu-dev

as well as some things above, and also need some xvfb as well

     sudo apt-get install xvfb
     Xvfb :1 -screen 0 1280x768x24 &
     export DISPLAY=:1

(Need to run the latter two commands each time you reboot the machine.)

Apparently one can search [packages.ubuntu.com](http://packages.ubuntu.com) to see which packages are missing.

To run cucumber tests successfully we used:

     bundle exec rake cucumber

Also we needed [https://www.digitalocean.com/community/articles/how-to-install-ruby-on-rails-on-ubuntu-12-04-lts-precise-pangolin-with-rvm](https://www.digitalocean.com/community/articles/how-to-install-ruby-on-rails-on-ubuntu-12-04-lts-precise-pangolin-with-rvm) to get rvm sorted

## Pair Programming with screen/ec2 notes

* [http://tarnbarford.net/journal/pair-programming](http://tarnbarford.net/journal/pair-programming)
* [http://blog.dustinkirkland.com/2009/04/teaching-class-with-gnu-screen.html](http://blog.dustinkirkland.com/2009/04/teaching-class-with-gnu-screen.html)
* [http://www.math.utah.edu/docs/info/screen_5.html](http://www.math.utah.edu/docs/info/screen_5.html)
* [https://github.com/tansaku/remote_pair_chef](https://github.com/tansaku/remote_pair_chef)