class ListInvitedUsers 
  def self.list(users)
    new(users).list 
  end

  def initialize(users) 
    @users = users
  end

  def list 
    users.each_with_object([]) do |user, array|
      org = user.organization
      array << build_invited_attributes(org, user) if org.present? # even though this should always be true ...
    end
  end

  private
  attr_reader :users 

  def build_invited_attributes(org, user)
    { id: org.id, 
      name: org.name, 
      email: user.email,
      date: user.invitation_sent_at }
  end

end
