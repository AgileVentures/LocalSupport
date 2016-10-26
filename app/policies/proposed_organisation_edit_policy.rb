class ProposedOrganisationEditPolicy < ApplicationPolicy

  def update?
    user.try(:superadmin?)
  end
end
