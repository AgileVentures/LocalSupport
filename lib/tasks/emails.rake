# rake db:import:emails[db/emails.csv]

begin
  namespace :db do
    namespace :import do
      desc 'Import email addresses from a named CSV file'
      task :emails, [:file] => :environment do |t, args|
        Logger.new(STDOUT).info 'Start emails import'
        # pass variables like so bundle exec rake db:import:emails[db/emails.csv]
        require File.expand_path("../../config/environment", File.dirname(__FILE__))
        #this is needed because rake tasks load classes lazily; from the command line, the task will
        #otherwise fail because it takes the below intended monkeypatch as first definition
        Rails.logger.tagged('IMPORT EMAILS') do
          Organisation.import_emails(args[:file],1000).split("\n").each { |msg| Rails.logger.info(msg) }
        end
        Logger.new(STDOUT).info 'Emails import finished'
      end
    end
  end
end
