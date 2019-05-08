begin
  namespace :db do
    desc 'Import organisations from kcsc-api'
    task import_kcsc: :environment do
      ImportKCSC.with
    end
  end
end
