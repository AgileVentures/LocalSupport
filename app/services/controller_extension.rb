module ControllerExtension
  def self.for(controller)
    controller.extend lookup_service(controller)
    controller.set_params
    controller.set_instance_variables
  end

  def self.lookup_service(controller)
    controller.params
              .fetch(:service)
              .prepend(controller.controller_name + '/')
              .camelize
              .constantize
  end
end
