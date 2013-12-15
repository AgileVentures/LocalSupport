require 'spec_helper'

describe 'organizations/show.html.erb' do

  let(:organization) do
    stub_model Organization, {
        :name => 'Friendly',
        :address => '12 pinner rd',
        :telephone => '1234',
        :email => 'admin@friendly.org',
        :postcode => 'HA1 4HZ',
        :website => 'http://www.friendly.org',
        :donation_info => 'http://www.friendly.org/donate'
    }
  end

  before(:each) { assign(:organization, organization) }

  context 'page styling' do
    it 'name should be wrapped in h3 tag' do
      render
      rendered.should have_css('h3', :text => organization.name)
    end
    it 'PRESENT: postcode, email, website, donation info' do
      render
      rendered.should have_content('Postcode: ')
      rendered.should have_content('Email: ')
      rendered.should have_css("a[href='mailto:#{organization.email}']")
      rendered.should have_content('Website: ')
      rendered.should have_selector 'a', :content => "#{organization.website}", :href => organization.website, :target => '_blank'
      rendered.should have_content('Donation Info: ')
      rendered.should have_selector 'a', :content => "Donate to #{organization.name} now!", :href => organization.donation_info, :target => '_blank'
    end
    it 'ABSENT: postcode, email, website, donation info' do
      # using empty string rather than nil to cover this likely corner case
      allow(organization).to receive(:postcode) { '' }
      allow(organization).to receive(:email) { '' }
      allow(organization).to receive(:website) { '' }
      allow(organization).to receive(:donation_info) { '' }
      render
      rendered.should_not have_content('Postcode: ')
      rendered.should_not have_content('Email: ')
      rendered.should_not have_css("a[href='mailto:#{organization.email}']")
      rendered.should_not have_content('Website: ')
      rendered.should_not have_selector 'a', :content => "#{organization.website}", :href => organization.website, :target => '_blank'
      rendered.should_not have_content('Donation Info: ')
      rendered.should_not have_selector 'a', :content => "Donate to #{organization.name} now!", :href => organization.donation_info, :target => '_blank'
    end
  end

  context 'some information is private' do
    it 'should not show telephone and address by default' do
      render
      rendered.should_not have_content organization.address
      rendered.should_not have_content organization.telephone
    end
    it 'should not show telephone and address by default' do
      render
      rendered.should_not have_link 'Edit'
    end
  end

  context 'edit button' do
    it 'renders edit button if editable true' do
      @editable = assign(:editable, true)
      render
      rendered.should have_link 'Edit', :href => edit_organization_path(organization.id)
    end
    it 'does not render edit button if editable false' do
      @editable = assign(:editable, false)
      render
      rendered.should_not have_link :href => edit_organization_path(organization.id)
    end
    it 'does not render edit button if editable nil' do
      @editable = assign(:editable, nil)
      render
      rendered.should_not have_link :href => edit_organization_path(organization.id)
    end
  end

  context 'this is my organization button' do
    let(:user) { stub_model User, :id => 2 }
    it 'renders grab button if grabbable true' do
      @grabbable = assign(:grabbable, true)
      view.stub(:current_user).and_return(user)
      render
      rendered.should have_link 'This is my organization', :href => organization_user_path(organization.id, user.id)
      #TODO should check hidden value for put
    end
    it 'does not render grab button if grabbable false' do
      @grabbable = assign(:grabbable, false)
      render
      rendered.should_not have_button('This is my organization')
    end
  end
end
