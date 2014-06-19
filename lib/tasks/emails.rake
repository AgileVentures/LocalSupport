# rake db:import:emails[db/emails.csv]

begin
  namespace :db do
    namespace :import do
      desc 'Import email addresses from a named CSV file'
      task :emails, [:file] => :environment do |t, args|
        # pass variables like so bundle exec rake db:import:emails[db/emails.csv]
        require File.expand_path("../../config/environment", File.dirname(__FILE__))
        #this is needed because rake tasks load classes lazily; from the command line, the task will
        #otherwise fail because it takes the below intended monkeypatch as first definition
        puts Organization.import_emails(args[:file],1000)
      end
    end
  end
end
