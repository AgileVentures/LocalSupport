class CategoryOrganisation < ActiveRecord::Base
  belongs_to :category
  belongs_to :base_organisation, :foreign_key => :organisation_id
  self.table_name = 'categories_organisations'
end
