begin
  namespace :db do
    task :categories => :environment do
      Category.seed
    end
  end
end