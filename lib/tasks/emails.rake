begin
  namespace :db do
    namespace :import do
      task :emails, [:file] => :environment do |t, args|
        # pass variables like so bundle exec rake db:import:emails[db/emails.csv]
        #Organization.acts_as_gmappable({ :check_process  => true })
        require File.expand_path("../../config/environment", File.dirname(__FILE__))
        #class Organization
        #private
        Organization.instance_eval do
          private :remove_errors_with_address do
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
