Rake::Task['db:setup'].clear
begin
  namespace :db do
    desc 'Setup project data'
    task :setup => :environment do

      Rake::Task['db:categories'].invoke
      Rake::Task['db:seed'].invoke
      Rake::Task['db:cat_org_import'].invoke
      Rake::Task['db:pages'].invoke
      Rake::Task['db:import:emails'].invoke('db/emails.csv')
      Rake::Task['db:email_template'].invoke
      Rake::Task['db:import_doit'].invoke
      Rake::Task['import_organisations'].invoke

    end
  end
end
