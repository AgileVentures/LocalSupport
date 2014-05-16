module Invitations
  extend self

  def collect_replies(params, invited_by)
    reduced(invited(parsed(params), invited_by))
  end

  private

  def parsed(params)
    Invitations::KeyMapper.(params)
  end

  def invited(params, invited_by)
    Invitations::Inviter.(params, invited_by)
  end

  def reduced(array_of_hashes)
    array_of_hashes.reduce({}, :update)
  end
end