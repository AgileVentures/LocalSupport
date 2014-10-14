module FormHelper
  def setup_organisation(organisation)
    (Category.all - organisation.categories).each do |category|
      organisation.category_organisations.build(:category => category)
    end
    organisation.category_organisations.sort! do |first, second|
      first_is_what_they_do = first.category.charity_commission_id < 200
      first_is_who_they_help = (first.category.charity_commission_id < 300) & (first.category.charity_commission_id > 199)
      first_is_how_they_help = (first.category.charity_commission_id < 400) & (first.category.charity_commission_id > 299)
      second_is_what_they_do = second.category.charity_commission_id < 200
      second_is_who_they_help = (second.category.charity_commission_id < 300) & (second.category.charity_commission_id > 199)
      second_is_how_they_help = (second.category.charity_commission_id < 400) & (second.category.charity_commission_id > 299)
      if first_is_what_they_do & second_is_what_they_do
        first.category.name <=> second.category.name
      elsif first_is_what_they_do & second_is_how_they_help
        -1
      elsif first_is_what_they_do & second_is_who_they_help
        -1
      elsif first_is_who_they_help & second_is_what_they_do
        1
      elsif first_is_who_they_help & second_is_who_they_help
        first.category.name <=> second.category.name
      elsif first_is_who_they_help & second_is_how_they_help
        -1
      elsif first_is_how_they_help & second_is_what_they_do
        1
      elsif first_is_how_they_help & second_is_who_they_help
        1
      elsif first_is_how_they_help & second_is_how_they_help
       first.category.name <=> second.category.name
      end
    end
    organisation
  end
end