class Service < ApplicationRecord
  scope :order_by_most_recent, -> { order('created_at DESC') }
  belongs_to :organisation

  def self.search_for_text(text)
    where('description LIKE ? OR name LIKE ?',
          "%#{text}%", "%#{text}%")
  end

  def self.from_model(model)
    service = Service.create(imported_at: model.imported_at)
    service.name = model.name
    service.description = model.description
    service.telephone = model.telephone
    service.email = model.email
    service.website = model.website
    service.address = model.address
    service.postcode = model.postcode
    service.latitude = model.latitude
    service.longitude = model.longitude
    service.save!
    service
  end
end
