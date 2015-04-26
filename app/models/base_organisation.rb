class BaseOrganisation < ActiveRecord::Base
  acts_as_paranoid
  validates_url :website, :prefferred_scheme => 'http://', :if => Proc.new{|org| org.website.present?}
  validates_url :donation_info, :prefferred_scheme => 'http://', :if => Proc.new{|org| org.donation_info.present?}
  has_many :category_base_organisations
  has_many :categories, :through => :category_base_organisations
  accepts_nested_attributes_for :category_base_organisations,
                                :allow_destroy => true
end
