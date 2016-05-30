# rake db:fix_invites

begin
  namespace :db do
   desc 'Link pending invited users to organisations'
   task :fix_invites => :environment do
      current_invites = User.invited_not_accepted
      nil_org_users = current_invites.select {|user| user.organisation_id.nil?}
      nil_org_users.each do |user|
        query_result = Organisation.where("UPPER(email) LIKE ? ", "%#{user.email.upcase}%")
        org = query_result.first
        puts "Wrong number of orgs: #{org.email}" if query_result.length != 1
        user.organisation_id = org.id
        user.save!
      end
    end
  end
end
