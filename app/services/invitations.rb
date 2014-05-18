module Invitations
  extend self

  def run_messages(params, invited_by)
    reduced(invite(parse(params), invited_by))
  end
  alias_method :call, :run_messages

  private

  def parse(params)
    Invitations::KeyMapper.(params)
  end

  def invite(params, invited_by)
    Invitations::Inviter.(params, invited_by)
  end

  def reduced(array_of_hashes)
    array_of_hashes.reduce({}, :update)
  end
end
