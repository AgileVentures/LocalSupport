# rake db:target_emails
require 'csv'
namespace :db do
  task :target_emails => :environment do
    orgs = Organization.all.select { |org| org.email.present? }
    orgs = orgs.select { |org| org.users.blank? }
    CSV.open("db/target_emails.csv", "wb") do |csv|
      orgs.each { |org| csv << [org.name, org.email] }
    end
  end
end
