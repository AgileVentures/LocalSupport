begin
  namespace :db do
    desc 'Generate friendly id for Organisations records'
    task :friendly_id => :environment do
      Logger.new(STDOUT).info 'Start friendly_id generation'
      Organisation.find_each do |org|
        WithoutTimestamps.run do
          org.slug = nil
          org.save
        end
      end
      Logger.new(STDOUT).info 'Friendly_id generation finished'
    end
  end
end
