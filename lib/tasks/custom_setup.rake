Rake::Task['db:setup'].clear
begin
  namespace :db do
    desc 'Setup project data'
    task :setup => :environment do

      Rake::Task['db:migrate'].invoke
      Rake::Task['db:categories'].invoke
      Rake::Task['db:seed'].invoke
      Rake::Task['db:cat_org_import'].invoke
      Rake::Task['db:pages'].invoke
      Rake::Task['db:import:emails'].invoke('db/emails.csv')

    end
  end
end
