class OrganisationReportPolicy < Struct.new(:user, :organisation_report)

  def without_users_index?
    user.try(:superadmin?)
  end
end
