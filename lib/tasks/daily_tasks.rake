begin
  namespace :db do
    desc 'Import volunteer opportunities from DoIt (http://do-it.org)'
    task :import_doit => :environment do
      ImportDoItVolunteerOpportunities.with(3.0)
    end
  end
  namespace :db do
    desc 'Import volunteer opportunities from Reachskills (https://reachskills.org.uk/)'
    task import_reachskills: :environment do
      ImportReachSkillsVolunteerOpportunities.with
    end
  end
end
