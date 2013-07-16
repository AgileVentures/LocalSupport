class Category < ActiveRecord::Base
  has_and_belongs_to_many :organizations
  def self.seed
     ['Amateur Sport', 'Animal Welfare', 'Arts, Culture, Heritage and Science',
     'Citizenship','Community Development','Diversity','Education','Environment',
     'Equality','Health','Human Rights','Poverty Relief and Prevention','Religion',
     'Rescue Services','Support'].each do |name|
       Category.create! :name => name
     end

  end
end