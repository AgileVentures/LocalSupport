class BatchInvite

  def initialize(flag)
    InvitationGem.prepare(Devise, flag)
  end

  def run(current_user, params)

    params.each_with_object({}) do |param, response|

      response[param[:id]] = invite(
        current_user,
        param[:email],
        param[:id]
      )

    end
  end

  private

  def invite(from, to, relation_id)
    invitee = User.invite!({email: to}, from)
    invitee.respond_to_invite(relation_id)
  end
end

class InvitationGem
  def self.prepare(gem, flag)
    gem.resend_invitation = to_boolean(flag)
  end

  private

  def to_boolean(flag)
    raise "#{flag} must respond to #to_s" unless flag.respond_to?(:to_s)
    flag = flag.to_s
    return true if flag == 'true'
    return false if flag == 'false'
    raise "cannot cast '#{flag}' to boolean"
  end
end
