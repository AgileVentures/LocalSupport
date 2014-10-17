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

  def self.first_category_name_in_each_type
    {what_they_do: first_category_name_in_what_they_do, who_they_help: first_category_name_in_who_they_help,
     how_they_help: first_category_name_in_how_they_help}
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
    @what_they_do = CategoryType.new(:what_they_do)
    @who_they_help = CategoryType.new(:who_they_help)
    @how_they_help = CategoryType.new(:how_they_help)
    class << self
      attr_reader :what_they_do, :who_they_help, :how_they_help
    end
  end

  def type
    return CategoryType.what_they_do if self.charity_commission_id < 200
    return CategoryType.who_they_help if (self.charity_commission_id < 300) & (self.charity_commission_id > 199)
    return CategoryType.how_they_help if (self.charity_commission_id < 400) & (self.charity_commission_id > 299)
  end

  def <=> other
    if (self.type <=> other.type) == 0
      self.name <=> other.name
    else
      self.type <=> other.type
    end
  end


  private
    def self.choose_first_in_range lower, upper
      category = self.all.sort!.select{|cat| (cat.charity_commission_id < upper)  & (cat.charity_commission_id > lower)}.first
      category.name if category
    end
    def self.first_category_name_in_what_they_do
      choose_first_in_range(0,200)
    end

    def self.first_category_name_in_who_they_help
      choose_first_in_range(199,300)
    end

    def self.first_category_name_in_how_they_help
      choose_first_in_range(299,400)
    end
end