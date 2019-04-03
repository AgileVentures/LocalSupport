Notes on OSX installation
==========================

In order to work on LocalSupport on Mac, please fork and clone the project.

If you need to setup your development environment then [gorails](https://gorails.com/setup/osx/10.13-high-sierra) has an excellent walkthrough.

1. Install [RVM](https://rvm.io/).
2. Install [Ruby 2.5.1](https://rvm.io/rubies/installing). 

    `rvm install ruby-2.5.1` 

    `rvm use 2.5.1`
3. Fork the http://github.com/AgileVentures/LocalSupport repo (fork button at top right of github web interface).
4. Clone the new forked repo onto your dev machine. `git clone https://github.com/YOUR-GITHUB-USERNAME/LocalSupport.git`
5. `cd LocalSupport`.
6. Install Qt webkit headers.
[Install Homebrew](https://brew.sh/) (if you don't have it already). If you do have Homebrew, run `brew update` and after brew is installed or updated, type `brew install qt@5.5` This will allow you to install capybara-webkit -v '1.15.0' successfully.

* If you are still unable to successfully install the caybara-webkit, try the following:  First `brew uninstall qt@5.5` to uninstall previous installation, then re-install using
`brew install qt@5.5 --with-qtwebkit`, and finally `brew link --force qt@5.5`.

* You may run into permission errors with XCode and need to install the [Xcode version from the App Store](https://itunes.apple.com/us/app/xcode/id497799835). Be sure to agree to the license agreement, as it can be a block: ![xcode-permission](https://dl.dropbox.com/s/tule4csnjcmdoez/xcode-permission.png) 
 
    Then run `sudo xcode-select --switch /Applications/Xcode.app`

7. Install [GNU IDN Library](http://www.gnu.org/software/libidn/#downloading)
which can be installed with brew:

    ```bash
    brew install libidn
    ```
8. Install [postgreSQL](https://postgresapp.com/).
Type `psql` into command line. Then you should see this:

        psql (9.3.4)
        Type "help" for help.
        username=#
Next to that type `ALTER ROLE "postgres" WITH CREATEDB`.  (You may need to create this role, see [issues](issues.md) for help.) Then type `\q` to exit psql

9. Run `bundle install` to get the gems.
    * If you have trouble installing the capybara-webkit gem, try the troubleshooting steps in step 6, above.
10. Run `npm install` to get the javascript dependencies.
11. Run the following to get the database set up and import seed data (**Note:** `db:setup` is a custom task that invokes all required import and seeds. )

    ```ruby
    bundle exec rails db:create
    bundle exec rails db:migrate
    bundle exec rails db:setup
    ```

If you hit problems, ask us on the AV Slack chat channel: [#localsupport-install](https://agileventures.slack.com/messages/C3QFDHMAM).

## Run locally
After that, you can run `rails server` and see that app running locally, by navigating to [http://localhost:3000](http://localhost:3000).

The db/seeds.rb task that you ran (with `bundle exec rails db:setup`) added some organizations and a test user that you can experiment with. Read that file for more information.

## Run tests

Also you should run the specs and cucumber features to make sure your installation is solid.

Before running the tests you should create a file named `config/application.yml` and add the following line:

```yaml
DOIT_HOST: 'http://api.qa2.do-it.org/v2'
```
also run the migrations for your test database:
 
    bundle exec rails db:migrate RAILS_ENV=test
    
then run tests using following commands:

    bundle exec rspec
    bundle exec cucumber


Issues
-------

* If you are having issues with PostgresQL - see [PostgreSQL install instructions](issues.md#postgresql-install)
