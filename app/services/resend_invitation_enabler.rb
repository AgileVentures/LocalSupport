class ResendInvitationEnabler 

  def self.enable(devise, flag)
    new(devise).enable(flag)
  end

  def initialize(devise)
    @devise = devise
  end

  def enable(flag)
    devise.resend_invitation = flag
  end

  private
  attr_reader :devise

end
