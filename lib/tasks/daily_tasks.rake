begin
  desc 'Import volunteer opportunities and post to Social Media'
  task daily_tasks: :environment do

    Rake::Task['db:import_doit'].invoke
    Rake::Task['db:import_reachskills'].invoke
    Rake::Task['update_social_media'].invoke
    Rake::Task['import_organisations'].invoke
  end
end
