begin
  namespace :db do
    task :categories => :environment do
      Category.seed 'db/charity_classifications.csv'
    end
    task :cat_org_import => :environment do
      Organisation.import_category_mappings 'db/data.csv' , 1006
    end
  end
end
