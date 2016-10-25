class OrganisationReportPolicy < Struct.new(:user, :organisation_report)

  def without_users_index?
    user.superadmin?
  end
end
