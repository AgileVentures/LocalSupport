class CategoryBaseOrganisation < ActiveRecord::Base
  belongs_to :category
  belongs_to :organisation
  self.table_name = 'categories_base_organisations'

  def <=> other
    self.category <=> other.category
  end
end