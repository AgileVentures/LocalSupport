require 'rails_helper'

describe "organisations/_form.html.erb", :type => :view do
  before :each do
    @categories_start_with = {what_they_do: 'alligator', who_they_help: 'crocodile', how_they_help: 'iguana'} 
    @organisation = Organisation.new(name: 'Sarah Plain and Tall Foundation')
    @category1 = FactoryGirl.create(:category, name: "alligator",  charity_commission_id: 100)
    @category2 = FactoryGirl.create(:category, name: "crocodile", charity_commission_id: 210)
    @category3 = FactoryGirl.create(:category, name: "iguana", charity_commission_id: 310)
    @category4 = FactoryGirl.create(:category, name: "capybara",  charity_commission_id: 101)
    @category5 = FactoryGirl.create(:category, name: "guinea pig", charity_commission_id: 201)
    @category6 = FactoryGirl.create(:category, name: "rabbit", charity_commission_id: 304)
    @organisation.categories << [@category1, @category3]
    @organisation.save!
    render partial: 'form', locals: {org: @organisation}
  end
  it "renders form partial even for empty Organisation" do
    expect(rendered).not_to be_nil
  end

  it "renders the form with placeholders" do

    hash = {
            'organisation_name' => 'Enter organisation name',
            'organisation_address'  => 'Enter organisation address',
            'organisation_postcode' => 'Enter organisation post code',
            'organisation_email' => 'Enter organisation email address',
            'organisation_description' => 'Enter organisation description',
            'organisation_website' => 'Enter organisation website url',
            'organisation_telephone' => 'Enter organisation phone number',
            'organisation_superadmin_email_to_add' => "You may add an organisation administrator email here",
            'organisation_donation_info' => 'Enter organisation donation url'
    }
    hash.each do |label,placeholder|
      expect(rendered).to have_xpath("(//td/input|//td/textarea)[@id='#{label}'][@placeholder='#{placeholder}']")
    end
  end

  it 'should have categories in scroll box ordered by type and name' do
    expect(rendered).to have_xpath("//div[contains(@class, 'category_type')]/child::*[1][contains(., 'What you do')]/following-sibling::div[1]/label[text()[contains(.,'alligator')]]")
    expect(rendered).to have_xpath("//div[contains(@class, 'category_type')]/child::*[1][contains(., 'What you do')]/following-sibling::div[2]/label[text()[contains(.,'capybara')]]")
    expect(rendered).to have_xpath("//div[contains(@class, 'category_type')]/child::*[1][contains(., 'Who you help')]/following-sibling::div[1]/label[text()[contains(.,'crocodile')]]")
    expect(rendered).to have_xpath("//div[contains(@class, 'category_type')]/child::*[1][contains(., 'Who you help')]/following-sibling::div[2]/label[text()[contains(.,'guinea pig')]]")
    expect(rendered).to have_xpath("//div[contains(@class, 'category_type')]/child::*[1][contains(., 'How you help')]/following-sibling::div[1]/label[text()[contains(.,'iguana')]]")
    expect(rendered).to have_xpath("//div[contains(@class, 'category_type')]/child::*[1][contains(., 'How you help')]/following-sibling::div[2]/label[text()[contains(.,'rabbit')]]")
  end

  it 'should have categories associated with organisation checked' do
    [@category1.name, @category3.name].each do |category|
      expect(rendered).to have_xpath("//div/label[text()[contains(.,'#{category}')]]/input[2][@checked='checked']")
    end
    [@category2.name, @category4.name,@category5.name,@category6.name].each do |category|
      expect(rendered).not_to have_xpath("//div/label[text()[contains(.,'#{category}')]]/input[2][@checked='checked']")
    end
  end
end
