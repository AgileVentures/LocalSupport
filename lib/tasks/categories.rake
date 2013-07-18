begin
  namespace :db do
    task :categories => :environment do
      Category.seed 'db/charity_classifications.csv'
    end
    task :cat_org_import => :environment do
      Organization.import_category_mappings 'db/data.csv' , 1
    end
  end
end