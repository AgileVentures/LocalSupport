class VolunteerOpPolicy < ApplicationPolicy
  # class Scope < Scope
  #   def resolve
  #     scope
  #   end
  # end

  def create?
    user.try(:superadmin?) || record.organisation.users.include?(user)
  end

  def update?
    user.try(:superadmin?) || record.organisation.users.include?(user)
  end

  def destroy?
    user.try(:superadmin?) || record.organisation.users.include?(user)
  end
end
