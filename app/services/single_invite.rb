class SingleInvite

  def initialize(org, email, &callable_on_error)
    @batch_invite = ::BatchInviteJob.new({:resend_invitation => false, :invite_list => {org.id.to_s => email}}, nil)
    @org_id = org.id
    @callable_on_error = callable_on_error
    @email = email
  end

  def invite_user
    result = batch_invite.run
    if result[org_id.to_s] != "Invited!"
      callable_on_error.call email, result[org_id.to_s]
    end
  end


  private
  attr_reader :batch_invite,:callable_on_error, :org_id, :email

end
