begin
  namespace :db do
    namespace :import do
      task :emails => :environment do
        Organization.import_emails('db/emails_test.csv',1000)
      end
    end
  end
end
