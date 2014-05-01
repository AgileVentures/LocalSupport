module ControllerHelpers
  def make_current_user_admin
    admin_user = double("User")
    admin_user.stub(:admin?).and_return(true)
    request.env['warden'].stub :authenticate! => admin_user
    controller.stub(:current_user).and_return(admin_user)
    return admin_user
  end

  def make_current_user_nonadmin
    nonadmin_user = double("User")
    nonadmin_user.stub(:admin?).and_return(false)
    request.env['warden'].stub :authenticate! => nonadmin_user
    controller.stub(:current_user).and_return(nonadmin_user)
    return nonadmin_user
  end
end

module RequestHelpers
  def login(user)
    post_via_redirect(
        user_session_path,
        {
            'user[email]' => user.email,
            'user[password]' => user.password
        }
    )
  end

  def collect_actions_for(controller)
    controller_name = controller.controller_name

    Rails.application.routes.routes.each_with_object({}) do |route, dict|
      if route.defaults[:controller] == controller_name
        action = route.defaults[:action]
        dict[action.to_sym] = Request.new({
            :controller => controller_name,
            :action => action,
            :verb => route.verb.source.gsub(/[$^]/, '').downcase,
            :parts => route.parts.reject { |part| part == :format },
            :params => {}
        })
      end
    end
  end

  class Request < OpenStruct
    def add_params(*new_params)
      [*new_params].each do |dict|
        params.merge!(dict)
      end
    end
  end

  class Routable
    include Rails.application.routes.url_helpers

    def initialize(request, object)
      @request = request
      @params = request.parts.each_with_object({}) do |part, dict|
        dict[part] = object.send(part)
      end.merge!(request.params)
    end

    def verb
      @request.verb.blank? ? 'get' : @request.verb
    end

    def url
      url_for(
          {
              :only_path => true,
              :action => @request.action,
              :controller => @request.controller
          }.merge!(@params)
      )
    end
  end

end