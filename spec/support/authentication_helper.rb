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
    post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => user.password
  end

  # def for_actions_in(controller, options = {})
  #   tapper ||= RouteTapper.new(controller, options)
  #   # tapper.anonymize_controller
  #   tapper.actions.each_pair do |action, command|
  #     yield(action, command)
  #     # eval("#{verb} :#{action}")
  #     # yield
  #   end
  # end

  # def RouteFinder(controller, options = {})
  #   RouteFinder.new(controller, options = {})
  # end

  # def find_routes_for(controller)
  #   controller_name = controller.to_s.chomp('Controller').downcase
  #   Rails.application.routes.routes.select do |route|
  #     route.defaults[:controller] == controller_name
  #   end
  # end

  class Request

  end

  class Route
    attr_accessor :param_keys

    def initialize(route)
      @route = route
      @param_keys = @route.parts.reject { |part| part == :format }
    end

    def verb
        verbs = %w(GET POST PUT DELETE)
        verbs.find { |verb| verb.match(@route.verb) }.downcase
    end

    def controller
      @route.defaults[:controller]
    end
  end

  def collect_routes_for(controller)
    controller_name = controller.to_s.chomp('Controller').downcase

    Rails.application.routes.routes.each_with_object({}) do |route, dict|
      if route.defaults[:controller] == controller_name
        action = route.defaults[:action].to_sym
        dict[action] = {
            :controller => controller_name,
            :action => action,
            :verb => route.verb.source.gsub(/[$^]/, '').downcase,
            :parts => route.parts.reject { |part| part == :format }
        }
      end
    end
  end

  class RouteInspector < Hash

    def initialize(controller)
      controller_name = controller.to_s.chomp('Controller').downcase

      Rails.application.routes.routes.each do |route|
        if route.defaults[:controller] == controller_name
          key = route.defaults[:action].to_sym
          value = {
              :controller => controller_name,
              :action => route.defaults[:action],
              :verb => route.verb.source.gsub(/[$^]/, '').downcase,
              :parts => route.parts.reject { |part| part == :format }
          }
          self.send(:[]=, key, value)
        end
      end
    end

    def only(*actions)
      # puts 'hi'
      # debugger
      # puts 'lo'

      sub_hash = self.dup
      sub_hash.each do |key, _|
        sub_hash.delete(key) unless actions.include? key
      end

      # self.select { |action, _| actions.include? action }
    end

    def except(*actions)
      self.reject { |action, _| actions.include? action }
    end

    def add_param(param_hash)
      puts 'hi'
      debugger
      puts 'lo'
      # action_list.each do |action|
      #   param_hash.each do |key, value|
      #     @actions[action][key] = value
      #   end
      # end
    end
  end

  # def Routable(object, options = {})
  #   Routable.new(object, options = {})
  # end


  class Routable
    include Rails.application.routes.url_helpers

    attr_reader :verb

    def initialize(object, routing_info = {})
      @object = object
      @verb = routing_info.delete(:verb)
      @param_keys = routing_info.delete(:param_keys)
      @routing_info = routing_info

      @param_keys.each do |key|
        @routing_info[key] = @object.send(key)
      end

      # puts 'hi'
      # debugger
      # puts 'lo'

      # options.each do |attribute, value|
      #   instance_variable_set("@#{attribute}", value)
      # end
    end

    def url
      url_for({:only_path => true}.merge!(@routing_info))
    end
  end
end