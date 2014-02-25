class UserInviter 

  def self.call(user_repository, email, current_user) 
    new(user_repository).call(email, current_user)
  end

  def initialize(user_repository)
    @user_repository = user_repository
  end

  def call(email, current_user)
    user_repository.invite!({email:email}, current_user)
  end

  private 
  attr_reader :user_repository
end
