# == Schema Information
#
# Table name: categories_organisations
#
#  id              :integer          not null, primary key
#  category_id     :integer
#  organisation_id :integer
#
# Indexes
#
#  index_categories_organisations_on_category_id      (category_id)
#  index_categories_organisations_on_organisation_id  (organisation_id)
#

class CategoryOrganisation < ApplicationRecord
  belongs_to :category
  belongs_to :base_organisation, :foreign_key => :organisation_id
  self.table_name = 'categories_organisations'
end
