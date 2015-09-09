class SingleInviteJob

  SingleInviteResult = Struct.new(:error) do
    def invited_user?
      error.blank?
    end
  end

  def initialize(org, email)
    @batch_invite = ::BatchInviteJob.new({:resend_invitation => false, :invite_list => {org.id.to_s => email}}, nil)
    @org_id = org.id
    @email = email
  end

  def invite_user
    result = batch_invite.run
    return SingleInviteResult.new(result[org_id.to_s]) if result[org_id.to_s] != "Invited!"
    SingleInviteResult.new
  end

  private
  attr_reader :batch_invite,:org_id, :email

end
