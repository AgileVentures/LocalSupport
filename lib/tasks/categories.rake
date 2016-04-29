begin
  namespace :db do
    desc 'Import categories from named CSV file '
    task :categories => :environment do
      Logger.new(STDOUT).info 'Start Categories seed'
      Category.seed 'db/charity_classifications.csv'
      Logger.new(STDOUT).info 'Categories seed finished'
    end
    desc 'Import category mapping from named CSV file'
    task :cat_org_import => :environment do
      Logger.new(STDOUT).info 'Start Category Organisation mapping seed'
      Organisation.import_category_mappings 'db/data.csv' , 1006
      Logger.new(STDOUT).info 'Mapping Category Organisation finished'
    end
  end
end
