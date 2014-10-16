class CategoryOrganisation < ActiveRecord::Base
  belongs_to :category
  belongs_to :organisation
  self.table_name = 'categories_organisations'

  def <=> other
    self_is_what_they_do = self.category.charity_commission_id < 200
    self_is_who_they_help = (self.category.charity_commission_id < 300) & (self.category.charity_commission_id > 199)
    self_is_how_they_help = (self.category.charity_commission_id < 400) & (self.category.charity_commission_id > 299)
    other_is_what_they_do = other.category.charity_commission_id < 200
    other_is_who_they_help = (other.category.charity_commission_id < 300) & (other.category.charity_commission_id > 199)
    other_is_how_they_help = (other.category.charity_commission_id < 400) & (other.category.charity_commission_id > 299)
    if self_is_what_they_do & other_is_what_they_do
      self.category.name <=> other.category.name
    elsif self_is_what_they_do & other_is_how_they_help
      -1
    elsif self_is_what_they_do & other_is_who_they_help
      -1
    elsif self_is_who_they_help & other_is_what_they_do
      1
    elsif self_is_who_they_help & other_is_who_they_help
      self.category.name <=> other.category.name
    elsif self_is_who_they_help & other_is_how_they_help
      -1
    elsif self_is_how_they_help & other_is_what_they_do
      1
    elsif self_is_how_they_help & other_is_who_they_help
      1
    elsif self_is_how_they_help & other_is_how_they_help
      self.category.name <=> other.category.name
    end
  end
end