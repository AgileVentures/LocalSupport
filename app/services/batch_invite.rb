class BatchInvite

  def initialize(to_class, from_class, by_whom)
    @to_class = to_class
    @from_class = from_class
    @by_whom = current_user
    @foreign_key = foreign_key.to_sym
  end

  def run(guest_list)
    guest.each_with_object({}) do |guest, response|
      invitee = @to_class.invite!({email: guest[:email]}, @by_whom)
      response[guest[:id]] = respond_to_invite(invitee, guest[:id])
    end
  end

  def respond_to_invite(invitee, relation_id)
    if invitee.errors.any?
      "Error: #{invitee.errors.full_messages.first}"
    else
      invitee.send(@foreign_key, relation_id)
      invitee.save!
      'Invited!'
    end
  end

  private

  def foreign_key
    @from_class.name.downcase + '_id='
  end
end

class InvitationGem
  def self.new(klass, gem, flag)
    @klass = klass
    gem.resend_invitation = to_boolean(flag)
  end

  def invite!(to, from)
    @klass.invite!({email: to}, from)
  end

end
