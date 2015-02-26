require 'rails_helper'

describe "organisations/edit.html.erb", :type => :view do
  before(:each) do
    @organisation = assign(:organisation, stub_model(Organisation,
                                                     :new_record? => false, :donation_info => "http://www.friendly.com/donate"
    ))
  end

  it "renders the edit organisation form" do
    view.lookup_context.prefixes = %w[organisations application]
    render
    expect(rendered).to have_xpath("//form[@action='#{organisation_path(@organisation)}'][@method='post']")
  end

  it "renders the edit organisation form with tooltips" do
    view.lookup_context.prefixes = %w[organisations application]

    render

    hash = {'organisation_name' => 'Enter a unique name',
            'organisation_address'  => 'Enter a complete address',
            'organisation_postcode' => 'Make sure post code is accurate',
            'organisation_email' => 'Make sure email is correct',
            'organisation_description' => "Enter a full description here\. When an individual searches this database all words in this description will be searched\.",
            'organisation_website' => 'Make sure url is correct',
            'organisation_telephone' => 'Make sure phone number is correct',
            'organisation_superadmin_email_to_add' => "Please enter the details of individuals from your organisation you would like to give permission to update your entry\. E-mail addresses entered here will not be made public\.",
            'organisation_donation_info' => 'Please enter a website here either to the fundraising page on your website or to an online donation site.',
            'organisation_publish_email' => 'Toggle to change the visibility of your email address',
            'organisation_publish_telephone' => 'Toggle to change the visibility of your telephone number',
            'organisation_publish_address' => 'Toggle to change the visibility of your address'
    }
    hash.each do |label,tooltip|
      expect(rendered).to have_xpath("//tr/td[contains(.,#{label})]/../td[@data-toggle=\"tooltip\"][@title=\"#{tooltip}\"]")
    end
  end

  context "fields are in order" do
    let(:organisation) do
      stub_model Organisation, {
          :name => 'Friendly',
          :address => '12 pinner rd',
          :description => 'lovely',
          :telephone => '1234',
          :email => 'superadmin@friendly.org',
          :postcode => 'HA1 4HZ',
          :website => 'http://www.friendly.org',
          :donation_info => 'http://www.friendly.org/donate',
          :publish_address => true,
          :publish_email => true,
          :publish_phone => true
      }
    end
    let(:fields) { ["organisation_name",
              "organisation_description",
              "Contact information",
              "organisation_address",
              "organisation_postcode",
              "organisation_email",
              "organisation_website",
              "organisation_telephone",
              "organisation_donation_info"
             ] }
    it "renders the fields" do
      render
      expect(fields.map { |f|  rendered.index(f) }).not_to include(nil)
    end
  it "renders the fields in order similar to edit template" do
    render
    fields = ["#{organisation.name}",
    					"#{organisation.description}",
              "#{organisation.address}",
              "#{organisation.postcode}",
              "#{organisation.email}",
              "#{organisation.website}",
              "#{organisation.telephone}",
              "#{organisation.donation_info}"
             ]
      indexes = fields.map { |element| rendered.index(element) }
      expect(indexes).to eq indexes.sort
    end

  end

  it "renders the donation_info url in edit form" do
    render
    expect(rendered).to have_field :organisation_donation_info,
                               :with => "http://www.friendly.com/donate"
  end

  it "renders a form field to add an superadministrator email" do
    render
    expect(rendered).to have_field :organisation_superadmin_email_to_add
  end

  it "renders a checkbox to make address public" do
    render
    expect(rendered).to have_xpath("//input[@id='organisation_publish_address'][@type='checkbox']")
  end

  it "renders a checkbox to make email public" do
    render
    expect(rendered).to have_xpath("//input[@id='organisation_publish_email'][@type='checkbox']")
  end

  it "renders a checkbox to make phone number public" do
    render
    expect(rendered).to have_xpath("//input[@id='organisation_publish_phone'][@type='checkbox']")
  end

  it 'renders an update button with Anglicized spelling of Organisation' do
    render
    expect(rendered).to have_xpath("//input[@type='submit'][@value='Update Organisation']")
  end
  #todo: move this into proper integration test to avoid the errors mocking
#out being coupled with rails

end
