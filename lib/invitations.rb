# The modules here that extend self are stateless singleton objects. They
# expose one public method, which is aliased to call for the convenient fact
# that DeviseUserInviter.call(...) can be written as DeviseUserInviter.(...).

module Invitations

  # This service works with a list of invites, passing each invite to
  # DeviseUserInviter for processing, and building a hash of invite responses such
  # that [{:relation_id => '1', :email => 'what@ever.com'}] gets reduced to
  # {'1' => 'Invited!'}. The Devise configuration option resend_invitation
  # is set here.

  module BatchInviteJob
    extend self

    def run(params, invited_by)
      resend_invitation = params.fetch(:resend_invitation)
      invite_list = params.fetch(:invite_list)

      devise_resend_invitation(resend_invitation)

      responses = invite_list.map do |invite_params|
        UserInviter.(invite_params, invited_by)
      end

      responses.reduce({}, :update)
    end
    alias_method :call, :run

    private

    def validate_params(params)
      params.fetch(:invite_list).map do |invite|

      end
    end

    def devise_resend_invitation(resend_invitation)
      Devise.resend_invitation = to_boolean(resend_invitation)
    end

    def to_boolean(flag)
      flag.to_s == 'true' ? true : false
    end
  end

  # This service tries to (re)?invite a single user and associate it with an
  # organization. It then extends the user and tells it to give its
  # status regarding the invitation.

  module UserInviter
    extend self

    def invite(params, invited_by)
      org_id, email = params.fetch(:id), params.fetch(:email)
      user = User.invite!({email: email}, invited_by) do |user|
        user.organization_id = org_id
      end
      user.extend InvitedUser
      {org_id => user.status}
    end
    alias_method :call, :invite
  end

  # This module is used for extending a recently-invited user so it can
  # report the success or failure of that invitation.

  module InvitedUser
    def status
      errors.any? ? failure_message : success_message
    end

    private

    def success_message
      'Invited!'
    end

    def failure_message
      errors.full_messages.map {|msg| sprintf('Error: %s', msg)}.join(' ')
    end
  end
end
