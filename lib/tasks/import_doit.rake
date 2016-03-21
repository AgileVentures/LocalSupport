begin
  namespace :db do
    task :import_doit => :environment do
      ImportDoItVolunteerOpportunities.with(3.0)
    end
  end
end