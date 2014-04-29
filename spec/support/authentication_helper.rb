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

  def for_actions_in(controller, options = {})
    tapper ||= RouteTapper.new(controller, options)
    # tapper.anonymize_controller
    tapper.actions.each_pair do |action, command|
      yield(action, command)
      # eval("#{verb} :#{action}")
      # yield
    end
  end

  # def RouteFinder(controller, options = {})
  #   RouteFinder.new(controller, options = {})
  # end

  class RouteFinder
    # include Rails.application.routes.url_helpers

    # attr_reader :actions

    def initialize(controller, options = {})
      @controller_name = controller.to_s.chomp('Controller').downcase
      @model_name = controller.to_s.chomp('Controller').singularize

      routes = Rails.application.routes.routes.select do |route|
        route.defaults[:controller] == @controller_name
      end

      @options = options

      @actions = routes.each_with_object({}) do |route, hsh|
        action = route.defaults[:action].to_sym
        verb = find_verb_from(route.verb)
        param_keys = find_param_keys_from(route.parts)
        hsh[action] = {
            :verb => verb,
            :controller => @controller_name,
            :action => action,
            :param_keys => param_keys
        }
      end
    end

    def find(options)
      if options[:only]
        @actions.select { |key, _| options[:only].include? key }
      elsif options[:except]
        @actions.select { |key, _| options[:except].exclude? key }
      else
        @actions
      end
    end

    def add_param(param_hash, action_list)
      action_list.each do |action|
        param_hash.each do |key, value|
          @actions[action][key] = value
        end
      end
    end

    private

    def find_verb_from(regex)
      actions = %w(GET POST PUT DELETE)
      actions.select { |a| a.match(regex) }.first.downcase
    end

    def find_param_keys_from(list)
      list.reject! { |elem| elem == :format }
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