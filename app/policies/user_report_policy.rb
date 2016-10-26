class UserReportPolicy < Struct.new(:user, :user_report)

  def access?
    user.try(:superadmin?)
  end
end
