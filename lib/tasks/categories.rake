begin
  namespace :db do
    desc 'Import categories from named CSV file '
    task :categories => :environment do
      puts 'Start Categories seed'
      Category.seed 'db/charity_classifications.csv'
      puts 'Categories seed finished'
    end
    desc 'Import category mapping from named CSV file'
    task :cat_org_import => :environment do
      puts 'Start Category Organisation mapping seed'
      Organisation.import_category_mappings 'db/data.csv' , 1006
      puts 'Mapping Category Organisation finished'
    end
  end
end
