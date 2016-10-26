class ProposedOrganisationPolicy < ApplicationPolicy

  def update?
    user.try(:superadmin?)
  end

  def destroy?
    user.try(:superadmin?)
  end
end
