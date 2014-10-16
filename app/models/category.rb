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
  class CategoryType
    attr_reader :sym
    
    def initialize sym
      @sym = sym
    end
    def <=> other
      if (@sym == :what_they_do && other.sym == :how_they_help) || (@sym == :what_they_do && other.sym == :who_they_help) ||
        (@sym == :who_they_help && other.sym == :how_they_help)
        -1
      elsif @sym == other.sym
        0
      else
        1
      end
    end
  end

  def type
    return CategoryType.new :what_they_do if self.charity_commission_id < 200
    return CategoryType.new :who_they_help if (self.charity_commission_id < 300) & (self.charity_commission_id > 199)
    return CategoryType.new :how_they_help if (self.charity_commission_id < 400) & (self.charity_commission_id > 299)
  end

  def <=> other
    if (self.type <=> other.type) == 0
      self.name <=> other.name
    else
      self.type <=> other.type
    end
  end
end