class ChangeEthnicCategoryToEthnicMinorities < ActiveRecord::Migration[4.2]
  def change
    ethnic = Category.find_by_name 'Ethnic'
    if ethnic
      ethnic.name = 'Ethnic Minorities'
      ethnic.save
    end
  end
end
