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
        :donation_info => 'http://www.friendly.org/donate',
        :publish_address => false,
        :publish_email => true,
        :publish_phone => false
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
    it 'should not show telephone and address by default but should show email by default' do
      render
      rendered.should_not have_content organization.address
      rendered.should_not have_content organization.telephone
      rendered.should have_content organization.email
    end
    it 'should not show edit button by default' do
      render
      rendered.should_not have_link 'Edit'
    end
  end

  it 'renders the actual address if publish address if true' do
    organization.publish_address = true
    render
    rendered.should have_content organization.address
  end
  
  it 'renders the actual phone if publish phone is true' do
    organization.publish_phone = true
    render
    rendered.should have_content organization.telephone
  end

  it 'does not render the actual email if publish email is false' do
    organization.publish_email = false
    render
    rendered.should_not have_content organization.email
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

  describe 'this is my organization button' do
    context 'logged in user' do
      let(:user) { stub_model User, :id => 2, :org_admin? => false }
      it 'renders grab button if grabbable true' do
        @grabbable = assign(:grabbable, true)
        view.stub(:current_user).and_return(user)
        render
        rendered.should have_link 'This is my organization', :href => user_report_path(organization_id: organization.id, id: user.id)
        #TODO should check hidden value for put
      end
      it 'does not render grab button if grabbable false' do
        @grabbable = assign(:grabbable, false)
        render
        rendered.should_not have_button('This is my organization')
      end
    end

    context 'user not logged in' do
      #let(:user) { stub_model User, :id => nil }
      it 'renders grab button' do
        @grabbable = assign(:grabbable, true)
        #view.stub(:current_user).and_return(user)
        render
        rendered.should have_link 'This is my organization', :href => new_user_session_path
        #TODO should check hidden value for put
      end
    end
  end

  describe 'create volunteer opportunity button' do
    let(:user) { stub_model User, :id => 2 }
    context 'logged in as org admin' do
      # When I am logged in as admin
      it 'should have a Create Volunteer Opportunity button' do
        user.stub :organization => organization
        view.stub :current_user => user
        assign(:editable, true)
        render
        rendered.should have_link 'Create Volunteer Opportunity', :href => new_volunteer_op_path
      end
    end
    context 'logged in but not an admin of this organization' do
      it 'should not have a Create Volunteer Opportunity button' do
        user.stub :org_admin? => false
        view.stub :current_user => user
        render
        rendered.should_not have_link 'Create Volunteer Opportunity'
      end
    end
    context 'not logged in' do
      it 'should not have a Create Volunteer Opportunity button' do
        render
        rendered.should_not have_link 'Create Volunteer Opportunity', :href => new_volunteer_op_path
      end
    end
  end
end


