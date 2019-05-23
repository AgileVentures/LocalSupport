require 'custom_errors'
require 'breadcrumbs_by_action'

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :store_location,
                :assign_footer_page_links,
                :set_tags

  # Add breadcrumb at home page.
  add_breadcrumb 'home', :root_path

  include CustomErrors
  WHITELISTED_CONTROLLERS = %w[
   application
   contributors
   organisations
   pages
   volunteer_ops
   events
 ]
  # To prevent infinite redirect loops, only requests from white listed
  # controllers are available in the "after sign-in redirect" feature
  def white_listed
    WHITELISTED_CONTROLLERS
  end
  # Devise wiki suggests we need to make this return nil for the
  # after_inactive_signup_path_for to be called in registrationscontroller
  # https://github.com/plataformatec/devise/wiki/How-To%3a-Change-the-redirect-path-after-destroying-a-session-i.e.-signing-out
  #Also documented on last stackoverflow answer here:
  #http://stackoverflow.com/questions/21571569/devise-after-sign-up-path-for-not-being-called
  def stored_location

  end
  def request_controller_is(white_listed)
    white_listed.include? request.params['controller']
  end

  def request_verb_is_get?
    request.env['REQUEST_METHOD'] == 'GET'
  end

  # Stores the URL if permitted
  def store_location
    return unless request_controller_is(white_listed) && request_verb_is_get?
    session[:previous_url] = request.fullpath
  end

  # Devise hook
  # Returns the users to the page they were viewing before signing in
  def after_sign_in_path_for(resource)
    set_flash_warning_reminder_to_update_details resource
    return edit_user_path id: current_user.id if session[:pending_organisation_id]
    return organisation_path(current_user.organisation) if current_user.organisation
    return session[:previous_url] if session[:previous_url]
    return requested_organisation_path if current_user.pending_organisation_id
    root_path
  end

  # Devise Invitable hook
  # Since users are invited to be org admins, we're delivering them to their page
  def after_accept_path_for(_resource)
    return organisation_path(current_user.organisation) if current_user.organisation
    root_path
  end


  def allow_cookie_policy
    response.set_cookie 'cookie_policy_accepted', 
        value: 'true',
        path: '/',
        expires: 1.year.from_now.utc
    #respond_to do |format|
    #  format.html redirect_to root_path
    #  format.json { render :nothing => true, :status => 200 }
    #end

    redirect_to request.referer || '/'
  end

  def add_breadcrumbs(default_title, title = nil, path = nil)
    bba = BreadcrumbsByAction.new(self, default_title, title, path)
    bba.send("#{action_name}_breadcrumb".to_sym)
  end

  def rendering(instance, notice, action)
    result = instance.save
    result ? redirect_to(instance, notice: notice) : render(action: action)
    result
  end

  private

  def iframe?
    params[:iframe]
  end

  # Enforces superadmin-only limits
  # http://railscasts.com/episodes/20-restricting-access
  def authorize
    return if superadmin?

    flash[:error] = t('authorize.superadmin')
    redirect_to root_path
    false
  end

  def superadmin?
    current_user.try :superadmin?
  end

  def assign_footer_page_links
    @footer_page_links = Page.visible_links
  end

  def set_flash_warning_reminder_to_update_details usr
    return unless usr.organisation and not usr.organisation.has_been_updated_recently?
    msg = render_to_string(
      partial: 'shared/call_to_action',
      locals: {org: usr.organisation}
    ).html_safe
    return flash[:warning] << ' ' << msg if flash[:warning]
    flash[:warning] = msg
  end

  def set_tags
    set_meta_tags title: meta_tag_title,
                  site: Setting.meta_tag_site,
                  reverse: true,
                  description: meta_tag_description,
                  author: 'http://www.agileventures.org',
                  og: open_graph_tags
  end

  def open_graph_tags
    {
        title: meta_tag_title,
        site: Setting.open_graph_site,
        reverse: true,
        description: meta_tag_description,
        author: 'http://www.agileventures.org'
    }
  end

  def method_missing(method_name, *args, &_block)
    methods = [:meta_tag_title, :meta_tag_description]
    return super(args) unless methods.include? method_name
    Setting.send(method_name)
  end

  def requested_organisation_path
    organisation_path(Organisation.find(current_user.pending_organisation_id))
  end

  def send_email_to_superadmin_about_request_for_admin_of org
    superadmin_emails = User.superadmins.pluck(:email)
    AdminMailer.new_user_waiting_for_approval(org.name, superadmin_emails).deliver_now
  end
end
