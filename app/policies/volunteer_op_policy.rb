class VolunteerOpPolicy < ApplicationPolicy

  def update?
    user.try(:superadmin?) || record.organisation.users.include?(user)
  end

  def destroy?
    user.try(:superadmin?) || record.organisation.users.include?(user)
  end
end
