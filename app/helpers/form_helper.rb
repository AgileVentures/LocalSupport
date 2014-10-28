module FormHelper
  def setup_organisation(organisation)
    (Category.all - organisation.categories).each do |category|
      organisation.category_organisations.build(:category => category)
    end
    organisation
  end
end