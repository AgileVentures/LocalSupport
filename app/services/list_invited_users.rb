class ListInvitedUsers 
  def self.list(users, organization_class) 
    new(users, organization_class).list 
  end

  def initialize(users, organization_class) 
    @users = users
    @organization_class = organization_class
  end

  def list 
    users.each_with_object([]) do |user, array|
      org = org(user.email)
      array << build_invited_if_organization_exists(org, user) if org.present?
    end
  end

  private
  attr_reader :users, :organization_class

  def build_invited_if_organization_exists(org, user)
    { id: org.id, 
      name: org.name, 
      email: org.email, 
      date: user.invitation_sent_at }
  end

  def org(user_email)
    organization_class.find_by_email(user_email)
  end

end
