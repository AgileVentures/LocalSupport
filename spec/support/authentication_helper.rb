module ControllerHelpers
  def make_current_user_superadmin(superadmin_user=double('user'))
    allow(superadmin_user).to receive(:superadmin?).and_return(true)
    allow(request.env['warden']).to receive_messages :authenticate! => superadmin_user
    allow(controller).to receive(:current_user).and_return(superadmin_user)
    superadmin_user
  end

  def make_current_user_nonsuperadmin
    nonsuperadmin_user = double("User")
    allow(nonsuperadmin_user).to receive(:superadmin?).and_return(false)
    allow(request.env['warden']).to receive_messages :authenticate! => nonsuperadmin_user
    allow(controller).to receive(:current_user).and_return(nonsuperadmin_user)
    nonsuperadmin_user
  end
end

module RequestHelpers
  def login(user)
    post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => user.password
  end
end
