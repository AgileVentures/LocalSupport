# == Schema Information
#
# Table name: self_care_category_services
#
#  id                    :bigint           not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  self_care_category_id :bigint
#  service_id            :bigint
#
# Indexes
#
#  index_self_care_category_services_on_self_care_category_id  (self_care_category_id)
#  index_self_care_category_services_on_service_id             (service_id)
#
# Foreign Keys
#
#  fk_rails_...  (self_care_category_id => self_care_categories.id)
#  fk_rails_...  (service_id => services.id)
#

class SelfCareCategoryService < ApplicationRecord
  belongs_to :self_care_category
  belongs_to :service
end
