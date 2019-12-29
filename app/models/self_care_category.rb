# == Schema Information
#
# Table name: self_care_categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SelfCareCategory < ApplicationRecord
  has_many :self_care_category_services
  has_many :services, through: :self_care_category_services
end
