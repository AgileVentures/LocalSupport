module ControllerExtension
  def self.for(controller)
    controller.params
              .fetch(:service)
              .prepend(name_of controller)
              .camelize
              .constantize
  end

  def self.name_of(controller)
    "controller_extensions/#{controller.controller_name}/"
  end
end
