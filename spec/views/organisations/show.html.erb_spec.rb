require 'spec_helper'

describe 'organisations/show.html.erb' do

  let(:organisation) do
    stub_model Organisation, {
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

  before(:each) { assign(:organisation, organisation) }

  context 'page styling' do
    it 'name should be wrapped in h3 tag' do
      render
      rendered.should have_css('h3', :text => organisation.name)
    end
    it 'PRESENT: postcode, email, website, donation info' do
      render
      rendered.should have_content('Postcode: ')
      rendered.should have_content('Email: ')
      rendered.should have_css("a[href='mailto:#{organisation.email}']")
      rendered.should have_content('Website: ')
      rendered.should have_selector 'a', :content => "#{organisation.website}", :href => organisation.website, :target => '_blank'
      rendered.should have_content('Donation Info: ')
      rendered.should have_selector 'a', :content => "Donate to #{organisation.name} now!", :href => organisation.donation_info, :target => '_blank'
    end
    it 'ABSENT: postcode, email, website, donation info' do
      # using empty string rather than nil to cover this likely corner case
      allow(organisation).to receive(:postcode) { '' }
      allow(organisation).to receive(:email) { '' }
      allow(organisation).to receive(:website) { '' }
      allow(organisation).to receive(:donation_info) { '' }
      render
      rendered.should_not have_content('Postcode: ')
      rendered.should_not have_content('Email: ')
      rendered.should_not have_css("a[href='mailto:#{organisation.email}']")
      rendered.should_not have_content('Website: ')
      rendered.should_not have_selector 'a', :content => "#{organisation.website}", :href => organisation.website, :target => '_blank'
      rendered.should_not have_content('Donation Info: ')
      rendered.should_not have_selector 'a', :content => "Donate to #{organisation.name} now!", :href => organisation.donation_info, :target => '_blank'
    end
  end
  context "fields are in order" do
    let(:organisation) do
      stub_model Organisation, {
          :id => '6',
          :name => 'Friendly',
          :address => '12 pinner rd',
          :description => 'lovely',
          :telephone => '1234',
          :email => 'admin@friendly.org',
          :postcode => 'HA1 4HZ',
          :website => 'http://www.friendly.org',
          :donation_info => 'http://www.friendly.org/donate',
          :publish_address => true,
          :publish_email => true,
          :publish_phone => true
      }
    end
    let(:fields) { ["#{organisation.name}",
              "#{organisation.description}",
              "#{organisation.address}",
              "#{organisation.postcode}",
              "#{organisation.email}",
              "#{organisation.website}",
              "#{organisation.telephone}",
              "#{organisation.donation_info}"
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
      indexes.should eq indexes.sort
    end

  end
  context 'some information is private' do
    it 'should not show telephone and address by default but should show email by default' do
      render
      rendered.should_not have_content organisation.address
      rendered.should_not have_content organisation.telephone
      rendered.should have_content organisation.email
    end
    it 'should not show edit button by default' do
      render
      rendered.should_not have_link 'Edit'
    end
  end

  it 'renders the actual address if publish address if true' do
    organisation.publish_address = true
    render
    rendered.should have_content organisation.address
  end
  
  it 'renders the actual phone if publish phone is true' do
    organisation.publish_phone = true
    render
    rendered.should have_content organisation.telephone
  end

  it 'does not render the actual email if publish email is false' do
    organisation.publish_email = false
    render
    rendered.should_not have_content organisation.email
  end
  
  context 'edit button' do
    it 'renders edit button if editable true' do
      assign(:editable, true)
      render
      rendered.should have_link 'Edit', :href => edit_organisation_path(organisation.id)   
    end
    it 'does not render edit button if editable false' do
      assign(:editable, false)
      render
      rendered.should_not have_link :href => edit_organisation_path(organisation.id)
    end
    it 'does not render edit button if editable nil' do
      assign(:editable, nil)
      render
      rendered.should_not have_link :href => edit_organisation_path(organisation.id)
    end
  end

  describe 'this is my organisation button' do
    context 'logged in user' do
      let(:user) { stub_model User, :id => 2, :org_admin? => false }
      it 'renders grab button if grabbable true' do
        assign(:grabbable, true)
        view.stub(:current_user).and_return(user)
        render
        rendered.should have_link 'This is my organisation', :href => user_report_path(organisation_id: organisation.id, id: user.id)
        #TODO should check hidden value for put
      end
      it 'does not render grab button if grabbable false' do
        assign(:grabbable, false)
        render
        rendered.should_not have_button('This is my organisation')
      end

    end

    context 'user not logged in' do
      #let(:user) { stub_model User, :id => nil }
      it 'renders grab button' do
        assign(:grabbable, true)
        #view.stub(:current_user).and_return(user)
        render
        rendered.should have_link 'This is my organisation', :href => new_user_session_path
        #TODO should check hidden value for put
      end
    end
  end

  describe 'pending admin status' do
    it 'displays pending admin message' do
      assign(:pending_admin, true)
      render
      rendered.should have_content 'Your request for admin status is pending.'
    end
  end

  describe 'create volunteer opportunity button' do
    it 'shows when belongs_to is true' do
      view.stub(:feature_active?).with(:volunteer_ops_create).and_return(true)
      assign(:can_create_volunteer_op, true)
      render
      rendered.should have_link 'Create a Volunteer Opportunity', :href => new_organisation_volunteer_op_path(organisation)
    end

    it 'does not shows when belongs_to is false' do
      assign(:can_create_volunteer_op, false)
      render
      rendered.should_not have_link 'Create a Volunteer Opportunity', :href => new_organisation_volunteer_op_path(organisation)
    end

    it 'is shown when feature is active' do
      assign(:can_create_volunteer_op, true)
      expect(view).to receive(:feature_active?).
        with(:volunteer_ops_create).and_return(true)
      render
      expect(rendered).to have_link \
        'Create a Volunteer Opportunity', :href => new_organisation_volunteer_op_path(organisation)      
    end

    it 'is not visible when feature is inactive' do
      assign(:can_create_volunteer_op, true)
      expect(view).to receive(:feature_active?).
        with(:volunteer_ops_create).and_return(false)
      render
      expect(rendered).not_to have_link \
        'Create a Volunteer Opportunity', :href => new_organisation_volunteer_op_path(organisation)
    end

  end

  describe 'show categories' do
    it 'handles no categories gracefully' do
      render
      expect(rendered).not_to have_content "Categories:"
      expect(rendered).not_to have_content "Animal Welfare"
      expect(rendered).not_to have_content "Sports"
    end

    it 'renders categories when present' do
      cats = [mock_model(Category, name: "Animal Welfare"), mock_model(Category, name: "Sports")]
      org = mock_model(Organisation, categories: cats)
      assign(:organisation, org)
      render
      expect(rendered).to have_content "Categories:"
      expect(rendered).to have_content "Animal Welfare"
      expect(rendered).to have_content "Sports"
    end
  end
end


