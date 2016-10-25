class InvitationPolicy < Struct.new(:user, :invitation)

  def create?
    user.superadmin?
  end
end
