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
      array << build_invited_attributes(org, user)
    end
  end

  private
  attr_reader :users 

  def build_invited_attributes(org, user)
    { id: org.id, 
      name: org.name, 
      email: org.email, 
      date: user.invitation_sent_at }
  end

end
