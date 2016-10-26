class OrganisationPolicy < ApplicationPolicy

  def create?
    user.try(:superadmin?)
  end

  def update?
    user.try(:superadmin?) || record.users.include?(user)
  end

  def destroy?
    user.try(:superadmin?)
  end

  def propose_edits?
    user && !update?
  end

  def grabbable?
    if user
     !user.superadmin? && record != user.organisation && user.pending_organisation != record
    else
      true
    end
  end

end
