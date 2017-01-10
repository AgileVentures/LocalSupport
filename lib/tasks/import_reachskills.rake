begin
  namespace :db do
    desc 'Import volunteer opportunities from DoIt (http://do-it.org)'
    task :import_reachskills => :environment do
      ImportReachSkillsVolunteerOpportunities.with()
    end
  end
end