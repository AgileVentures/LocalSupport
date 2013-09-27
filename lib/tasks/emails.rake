begin
  namespace :db do
    namespace :import do
      task :emails, [:file] => :environment do |t, args|
        # pass variables like so bundle exec rake db:import:emails[db/emails.csv]
        require File.expand_path("../../config/environment", File.dirname(__FILE__))
        #this is needed because rake tasks load classes lazily; from the command line, the task will
        #otherwise fail because it takes the below intended monkeypatch as first definition
        Organization.to_s
        class Organization
          private 
          def remove_errors_with_address
            errors_hash = errors.to_hash
            errors.clear
            errors_hash.each do |key, value|
              logger.warn "#{key} --> #{value}"
              if key.to_s != 'gmaps4rails_address'
                errors.add(key, value)
              end
            end
          end
        end
        Organization.import_emails(args[:file],1000)
      end
    end
  end
end
