# rake db:fix_invites

begin
  namespace :db do
   task :fix_invites => :environment do
      current_invites = User.invited_not_accepted
      nil_org_users = current_invites.select {|user| user.organization_id.nil?}
      nil_org_users.each do |user|
        query_result = Organization.where("UPPER(email) LIKE ? ", "%#{user.email.upcase}%")
        raise("Wrong number of orgs") if query_result.length != 1
        org = query_result.first
        user.organization_id = org.id
        user.save!
      end
    end
  end
end
