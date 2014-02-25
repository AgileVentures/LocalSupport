class UserInviter 
  def initialize(listener, user_repository, current_user) 
    @user_repository = user_repository
    @current_user = current_user
    @listener = listener
  end

  def invite(email, user_to_invite, dom_id)
    add_error_if_present(user_to_invite)
    sent_invite(user_to_invite, email)
    msg = user_to_invite.errors.any? ? user_to_invite.error_message : 'Invited!'
    listener.build_response(msg, dom_id)
  end

  private 
  attr_reader :user_repository, :current_user, :listener

  def sent_invite(user_to_invite, email)
    unless user_to_invite.present?
      user_repository.invite!({email:email}, current_user)
    end
  end

  def add_error_if_present(user_to_invite)
    if user_to_invite.present?
      user_to_invite.errors.add(:email, 'has already been taken')
    end 
  end
end
