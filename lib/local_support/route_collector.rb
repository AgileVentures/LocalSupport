module RouteCollector

  def collect_actions_for(controller)
    controller_name = controller.controller_name

    Rails.application.routes.routes.each_with_object({}) do |route, dict|
      if route.defaults[:controller] == controller_name
        action = route.defaults[:action]
        dict[action.to_sym] = Request
        .new({
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

  def route_request_for(request, object)
    Routable.new(request, object)
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