class AddSearchInputBarOnOrgPages < ActiveRecord::Migration
  def up
    Feature.create(name: :search_input_bar_on_org_pages)
  end

  def down
    Feature.find_by(name: :search_input_bar_on_org_pages).destroy
  end
end
