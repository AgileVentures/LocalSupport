class InvitationPolicy < Struct.new(:user, :invitation)

  def create?
    user.try(:superadmin?)
  end
end
