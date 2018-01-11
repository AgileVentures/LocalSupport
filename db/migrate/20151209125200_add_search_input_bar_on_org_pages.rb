class AddSearchInputBarOnOrgPages < ActiveRecord::Migration[4.2]
  def up
    Feature.create(name: :search_input_bar_on_org_pages)
  end

  def down
    Feature.find_by(name: :search_input_bar_on_org_pages).destroy
  end
end
