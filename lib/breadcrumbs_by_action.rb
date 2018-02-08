class BreadcrumbsByAction

  def initialize(controller, default_title, title = nil, path = nil)
    @controller = controller
    @title = title
    @default_title = default_title
    @path = path
  end

  def index_breadcrumb
  end

  def create_breadcrumb
  end

  def search_breadcrumb
  end

  def update_breadcrumb
  end

  def embedded_map_breadcrumb
  end

  def destroy_breadcrumb
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
