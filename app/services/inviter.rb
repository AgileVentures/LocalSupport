class Inviter
  def initialize(klass, gem, flag)
    @klass = klass
    @gem = gem
    @gem.resend_invitation = to_boolean(flag)
  end

  def rsvp(to_whom, from_whom, relation_id)
    invitee = @klass.invite!({email: to_whom}, from_whom)
    invitee.respond_to_invite(relation_id)
  end

  private
  attr_reader :klass

  def to_boolean(str)
    return true if str.to_s == 'true'
    return false if str.to_s == 'false'
    raise "cannot cast '#{str}' to boolean"
  end

end
