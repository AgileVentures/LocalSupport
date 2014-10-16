require 'csv'

class Category < ActiveRecord::Base
  has_many :category_organisations
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

  def self.first_category_name_in_what_they_do
    category = self.all.sort!.select{|cat| cat.charity_commission_id < 200}.first
    if category
      category.name
    end
  end

  def self.first_category_name_in_who_they_help
    category = self.all.sort!.select{|cat| (cat.charity_commission_id < 300)  & (cat.charity_commission_id > 199)}.first
    if category
      category.name
    end
  end

  def self.first_category_name_in_how_they_help
    category = self.all.sort!.select{|cat| (cat.charity_commission_id < 400)  & (cat.charity_commission_id > 299)}.first
    if category
      category.name
    end
  end

  def <=> other
    self_is_what_they_do = self.charity_commission_id < 200
    self_is_who_they_help = (self.charity_commission_id < 300) & (self.charity_commission_id > 199)
    self_is_how_they_help = (self.charity_commission_id < 400) & (self.charity_commission_id > 299)
    other_is_what_they_do = other.charity_commission_id < 200
    other_is_who_they_help = (other.charity_commission_id < 300) & (other.charity_commission_id > 199)
    other_is_how_they_help = (other.charity_commission_id < 400) & (other.charity_commission_id > 299)
    if self_is_what_they_do & other_is_what_they_do
      self.name <=> other.name
    elsif self_is_what_they_do & other_is_how_they_help
      -1
    elsif self_is_what_they_do & other_is_who_they_help
      -1
    elsif self_is_who_they_help & other_is_what_they_do
      1
    elsif self_is_who_they_help & other_is_who_they_help
      self.name <=> other.name
    elsif self_is_who_they_help & other_is_how_they_help
      -1
    elsif self_is_how_they_help & other_is_what_they_do
      1
    elsif self_is_how_they_help & other_is_who_they_help
      1
    elsif self_is_how_they_help & other_is_how_they_help
      self.name <=> other.name
    end
  end
end