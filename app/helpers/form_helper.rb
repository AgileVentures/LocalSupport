module FormHelper
  def setup_organisation(organisation)
    (Category.all - organisation.categories).each do |category|
      organisation.category_organisations.build(:category => category)
    end
    organisation.category_organisations.sort! do |first, second|
      first <=> second
    end
    organisation
  end
end