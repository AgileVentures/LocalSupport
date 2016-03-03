begin
  namespace :db do
    task :import_doit => :environment do
      ImportDoItVolunteerOpportunities.with
    end
  end
end