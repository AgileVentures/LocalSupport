module ControllerExtensions
  module Organisations::Defaults
    def set_params
      defaults = {
        layout: 'two_columns',
        template: 'index',
        scopes: ['order_by_most_recent'],
      }
      defaults.each do |k, v|
        params[k] = v if !admin? || params[k].nil?
      end
      params[:template].prepend(controller_name + '/')
    end

    def set_instance_variables
      @organisations = apply_scopes(Organisation)
    end

    def apply_scopes(klass)
      params[:scopes].each { |s| klass = klass.send(s) }
      klass
    end
  end
end
