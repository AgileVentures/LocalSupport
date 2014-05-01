require 'ostruct'

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

  class Route < OpenStruct
    # attr_accessor :parts
    #
    # def initialize(route)
    #   @route = route
    #   @parts = @route.parts.reject { |part| part == :format }
    #   @params = []
    # end
    #
    # def verb
    #   @route.verb.source.gsub(/[$^]/, '').downcase
    # end
    #
    # def controller
    #   @route.defaults[:controller]
    # end

    def add_params(*new_params)
      params.push(*new_params)
    end
  end

  def collect_routes_for(controller)
    controller_name = controller.to_s.chomp('Controller').downcase

    Rails.application.routes.routes.each_with_object({}) do |route, dict|
      if route.defaults[:controller] == controller_name
        action = route.defaults[:action]
        dict[action.to_sym] = OpenStruct.new({
            :controller => controller_name,
            :action => action,
            :verb => route.verb.source.gsub(/[$^]/, '').downcase,
            :parts => route.parts.reject { |part| part == :format },
            :params => []
        }) do
          def add_params(*new_params)
            params.push(*new_params)
          end
        end
      end
    end
  end

  class RouteCollector < Hash

    def initialize(controller)
      controller_name = controller.to_s.chomp('Controller').downcase

      Rails.application.routes.routes.each do |route|
        if route.defaults[:controller] == controller_name
          action = route.defaults[:action]
          self.send(:[]=, action.to_sym, Route.new(route))
        end
      end
    end

    def only(*actions)
      @routes.select { |action, _| actions.include? action }
    end

    def except(*actions)
      @routes.reject { |action, _| actions.include? action }
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