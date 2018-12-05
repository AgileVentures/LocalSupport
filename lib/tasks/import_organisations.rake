begin
  namespace :db do
    desc 'Import organisations from charity-commission-api'
    task :import_organisations => :environment do
      ImportOrganisations.with
    end
  end
end
