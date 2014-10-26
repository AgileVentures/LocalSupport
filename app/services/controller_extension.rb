module ControllerExtension
  def self.for(controller)
    controller.params
              .fetch(:service)
              .prepend(name_of controller)
              .camelize
              .constantize
              .check_permissions(controller)
  end

  def self.name_of(controller)
    "controller_extensions/#{controller.controller_name}/"
  end
end
