class BreadcrumbsByAction

  def initialize(controller, default_title, title = nil, path = nil)
    @controller = controller
    @title = title
    @default_title = default_title
    @path = path
  end

  def method_missing(method_name)
    super unless method_name.to_s.include?('_breadcrum')
  end

  def show_breadcrumb
    controller.send(:add_breadcrumb, title) if title.present?
  end

  def edit_breadcrumb
    controller.send(:add_breadcrumb, title, path) if title.present?
    controller.send(:add_breadcrumb, "Edit #{default_title}")
  end

  def new_breadcrumb
    controller.send(:add_breadcrumb, "New #{default_title}")
  end

  private

  attr_reader :controller, :title, :path, :default_title

end
