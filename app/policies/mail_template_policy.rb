class MailTemplatePolicy < ApplicationPolicy

  def update?
    user.try(:superadmin?)
  end
end
