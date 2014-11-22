module ControllerHelpers
  def make_current_user_admin(admin_user=double('user'))
    allow(admin_user).to receive(:admin?).and_return(true)
    request.env['warden'].stub :authenticate! => admin_user
    allow(controller).to receive(:current_user).and_return(admin_user)
    admin_user
  end

  def make_current_user_nonadmin
    nonadmin_user = double("User")
    allow(nonadmin_user).to receive(:admin?).and_return(false)
    request.env['warden'].stub :authenticate! => nonadmin_user
    allow(controller).to receive(:current_user).and_return(nonadmin_user)
    nonadmin_user
  end
end

module RequestHelpers
  def login(user)
    post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => user.password
  end
end
