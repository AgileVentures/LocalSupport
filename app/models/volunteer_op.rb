class VolunteerOp < ActiveRecord::Base
  acts_as_paranoid
  validates :title, :description, presence: true
  validates :organisation_id, presence: true, if: "source == 'local'"
  belongs_to :organisation

  scope :order_by_most_recent, -> { order('updated_at DESC') }
  scope :local_only, -> { where(source: 'local') }

  def organisation_name
    return organisation.name if source == 'local'
    doit_org_name
  end

  def organisation_link
    return organisation if source == 'local'
    "https://do-it.org/organisations/#{doit_org_link}"
  end

  def link
    return self if source == 'local'
    "https://do-it.org/opportunities/#{doit_op_id}"
  end

  def self.search_for_text(text)
     keyword = "%#{text}%"
     where(contains_description?(keyword).or(contains_title?(keyword)))
  end

  def self.contains_description?(text)
    arel_table[:description].matches(text)
  end

  def self.contains_title?(text)
    arel_table[:title].matches(text)
  end
end
