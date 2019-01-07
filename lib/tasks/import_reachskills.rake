begin
  namespace :db do
    desc 'Import volunteer opportunities from Reachskills (https://reachvolunteering.org.uk/)'
    task import_reachskills: :environment do
      ImportReachSkillsVolunteerOpportunities.with
    end
  end
end
