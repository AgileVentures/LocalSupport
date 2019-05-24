class Service < ApplicationRecord
  scope :order_by_most_recent, -> { order('created_at DESC') }

  def self.search_for_text(text)
    where('contact_id LIKE ? OR display_name LIKE ?',
          "%#{text}%", "%#{text}%")
  end
end
