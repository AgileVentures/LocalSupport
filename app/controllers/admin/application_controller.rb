# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin

    # annoyingly duplicated logic from ::ApplicationController, 
    # which we can't seem to access
    def authenticate_admin
      return if superadmin?

      flash[:error] = t('authorize.superadmin')
      redirect_to root_path
      false
    end

    def superadmin?
      current_user.try :superadmin?
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
