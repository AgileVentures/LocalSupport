class BatchInvite

  def initialize(to_class, from_class, foreign_key, by_whom)
    @to_class = to_class
    @from_class = from_class
    @foreign_key = foreign_key
    @by_whom = by_whom
  end

  def run(invite_list)
    invite_list.each_with_object({}) do |invite, response|
      invitee = @to_class.invite!({email: invite[:email]}, @by_whom)
      response[invite[:id]] = respond_to_invite(invitee, invite[:id])
    end
  end

  private

  def respond_to_invite(invitee, relation_id)
    if invitee.errors.any?
      "Error: #{invitee.errors.full_messages.first}"
    else
      invitee.send(@foreign_key, relation_id)
      invitee.save!
      'Invited!'
    end
  end

end
