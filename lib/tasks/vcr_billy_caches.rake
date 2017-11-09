namespace :vcr_billy_caches do
  desc 'resets all vcr and billy caches to their default state in current git branch'
  task reset: :environment do
    `rm -rf features/req_cache`
    `rm -rf features/vcr_cassettes`
    `git checkout features/req_cache`
    `git checkout features/vcr_cassettes`
  end

end
