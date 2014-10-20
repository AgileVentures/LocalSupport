class CategoryOrganisation < ActiveRecord::Base
  belongs_to :category
  belongs_to :organisation
  self.table_name = 'categories_organisations'

  def <=> other
    self.category <=> other.category
  end
end