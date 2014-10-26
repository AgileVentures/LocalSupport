module ControllerExtensions
  module Organisations::Index
    include Defaults

    def set_params
      super
    end

    def set_instance_variables
      super
      @json = gmap4rails_with_popup_partial(@organisations, 'popup')
      @category_options = Category.html_drop_down_options
    end
  end
end
