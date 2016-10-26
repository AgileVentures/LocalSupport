class PagePolicy < ApplicationPolicy

  def index?
    user.try(:superadmin?)
  end

  def create?
    user.try(:superadmin?)
  end

  def update?
    user.try(:superadmin?)
  end

  def destroy?
    user.try(:superadmin?)
  end
end
