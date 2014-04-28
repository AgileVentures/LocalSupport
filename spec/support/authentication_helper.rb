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

  class RouteFinder
    include Rails.application.routes.url_helpers

    attr_reader :actions

    def initialize(controller, options = {})
      controller_name = controller.to_s.chomp('Controller').downcase

      routes = Rails.application.routes.routes.select do |route|
        route.defaults[:controller] == controller_name
      end

      @options = options

      @actions = routes.each_with_object({}) do |route, hsh|
        action = route.defaults[:action].to_sym
        verb = find_verb_from(route.verb)
        hsh[action] = verb
      end
    end

    def add_matcher(hsh, keys)
      keys.each do |key|
        @actions[key].merge! hsh
      end
    end

    def make_urls
      @actions.each do |action|
        @actions[action][:url] = url_for({:only_path => true, :controller => @controller_name}.merge!(action))
      end
    end

    def find(options)
      if options[:only]
        @actions.select { |key, _| @options[:only].include? key }
      elsif options[:except]
        @actions.select { |key, _| @options[:except].exclude? key }
      else
        @actions
      end
    end

    private

    def find_verb_from(regex)
      actions = %w(GET POST PUT DELETE)
      actions.select { |a| a.match(regex) }.first.downcase
    end
  end
end