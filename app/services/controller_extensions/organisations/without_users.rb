module ControllerExtensions
  module Organisations::WithoutUsers
    include Organisations::Defaults

    def set_params
      params.merge!({
        template: 'without_users_index',
        layout: 'invitation_table',
        scopes: ['not_null_email','null_users','without_matching_user_emails'],
      })
      super
    end

    def set_instance_variables
      super
      @resend_invitation = false
    end
  end
end
