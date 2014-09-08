require 'csv'

class Category < ActiveRecord::Base
  has_and_belongs_to_many :organisations

  @@column_mappings = {
      cc_id: 'CharityCommissionID',
      cc_name: 'CharityCommissionName',
      name: 'Name'
  }

  def self.seed(csv_file)
    csv_text = File.open(csv_file, 'r:ISO-8859-1')
    CSV.parse(csv_text, :headers => true).each do |row|
      Category.create! :name => row[@@column_mappings[:name]].strip,
                       :charity_commission_id => row[@@column_mappings[:cc_id]],
                       :charity_commission_name => row[@@column_mappings[:cc_name]].strip
    end
  end

  def self.html_drop_down_options
    self.where('charity_commission_id < 199').order('name ASC').collect {|category| [ category.name, category.id ] }
  end
end