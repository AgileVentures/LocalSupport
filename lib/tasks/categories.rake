begin
  namespace :db do
    task :categories => :environment do
      Category.seed 'db/charity_classifications.csv'
    end
  end
end