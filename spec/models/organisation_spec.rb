require 'rails_helper'

describe Organisation, :type => :model do

  before do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions

    @category1 = FactoryGirl.create(:category, :charity_commission_id => 207)
    @category2 = FactoryGirl.create(:category, :charity_commission_id => 305)
    @category3 = FactoryGirl.create(:category, :charity_commission_id => 108)
    @category4 = FactoryGirl.create(:category, :charity_commission_id => 302)
    @category5 = FactoryGirl.create(:category, :charity_commission_id => 306)
    @org1 = FactoryGirl.build(:organisation, :email => "", :name => 'Harrow Bereavement Counselling', :description => 'Bereavement Counselling', :address => '84 pinner road', :postcode => 'HA1 4HA', :donation_info => 'www.harrow-bereavment.co.uk/donate')
    @org1.save!
    @org2 = FactoryGirl.build(:organisation, :name => 'Indian Elders Association',:email => "",
                              :description => 'Care for the elderly', :address => '64 pinner road', :postcode => 'HA1 4HZ', :donation_info => 'www.indian-elders.co.uk/donate')
    @org2.categories << @category1
    @org2.categories << @category2
    @org2.categories << @category3
    @org2.save!
    @org3 = FactoryGirl.build(:organisation, :email => "", :name => 'Age UK Elderly', :description => 'Care for older people', :address => '64 pinner road', :postcode => 'HA1 4HZ', :donation_info => 'www.age-uk.co.uk/donate')
    @org3.categories << @category1
    @org3.save!

    FactoryGirl.create :invitation_instructions
  end

  describe "#gmaps4rails_marker_attrs" do

    def build_org_with_computed_fields_and_updated_at org, updated_at = nil
      org.update_attributes(updated_at: updated_at) unless updated_at.nil?
      Queries::Organisations.add_recently_updated_and_has_owner(Organisation.where(id: org.id)).first
    end
    context 'no user' do
      it 'returns small icon when no associated user' do
        expect(build_org_with_computed_fields_and_updated_at(@org1).gmaps4rails_marker_attrs).to eq(['measle.png',
          {'data-id'=>@org1.id, :class=>'measle'}])
      end
    end

    context 'has user' do
      before(:each) do
        usr = FactoryGirl.create(:user, :email => 'orgsuperadmin@org.org')
        usr.confirm!
        @org1.users << [usr]
        @org1.save!
      end
      it 'returns large icon when there is an associated user' do
        expect(build_org_with_computed_fields_and_updated_at(@org1).gmaps4rails_marker_attrs).to eq( ['marker.png',
          {'data-id'=>@org1.id,:class=>'marker'}])
      end

      [ 365, 366, 500 ].each do |days|
        it 'returns small icon when update is #{days} days old' do
          # adds generous 5 second pad for query to run
          past_time = days == 365 ? Time.current.advance(years: -1) : Time.current.advance(days: -days)
          past_time = past_time.advance(seconds: -5)
          expect(
            build_org_with_computed_fields_and_updated_at(
              @org1, past_time
            ).gmaps4rails_marker_attrs
          ).to eq([
            'measle.png',
            {'data-id'=>@org1.id, :class=>'measle'}
          ])
        end
      end
      [ 2, 100, 200, 364].each do |days|
        it "returns large icon when update is only #{days} days old" do
          past_time = Time.at(Time.now - days.day)
          expect(build_org_with_computed_fields_and_updated_at(@org1, past_time).gmaps4rails_marker_attrs).to eq( ['marker.png',
            {'data-id'=>@org1.id, :class=>'marker'} ])
        end
      end
    end
  end
  context 'scopes for orphan orgs' do
    before(:each) do
      @user = FactoryGirl.create(:user, :email => 'hello@hello.com')
      @user.confirm!
    end

    it 'should allow us to grab orgs with emails' do
      expect(Organisation.not_null_email).to eq []
      @org1.email = 'hello@hello.com'
      @org1.save
      expect(Organisation.not_null_email).to eq [@org1]
    end

    it 'should allow us to grab orgs with no superadmin' do
      expect(Organisation.null_users.sort).to eq [@org1, @org2, @org3].sort
      @org1.email = 'hello@hello.com'
      @org1.save
      @user.confirm!
      expect(@org1.users).to eq [@user]
      expect(Organisation.null_users.sort).to eq [@org2, @org3].sort
    end

    it 'should allow us to exclude previously invited users' do
      @org1.email = 'hello@hello.com'
      @org1.save
      expect(Organisation.without_matching_user_emails).not_to include @org1
    end

    # Should we have more tests to cover more possible combinations?
    it 'should allow us to combine scopes' do
      @org1.email = 'hello@hello.com'
      @org1.save
      @org3.email = 'hello_again@you_again.com'
      @org3.save
      expect(Organisation.null_users.not_null_email.sort).to eq [@org1, @org3]
      expect(Organisation.null_users.not_null_email.without_matching_user_emails.sort).to eq [@org3]
    end
  end

  context 'validating URLs' do
    subject(:no_http_org) { FactoryGirl.build(:organisation, :name => 'Harrow Bereavement Counselling', :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 4HZ', :donation_info => 'www.harrow-bereavment.co.uk/donate') }
    subject(:empty_website)  {FactoryGirl.build(:organisation, :name => 'Harrow Bereavement Counselling', :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 4HZ', :donation_info => '', :website => '')}
    it 'if lacking protocol, http is prefixed to URL when saved' do
      no_http_org.save!
      expect(no_http_org.donation_info).to include('http://')
    end

    it 'a URL is left blank, no validation issues arise' do
      expect {no_http_org.save! }.to_not raise_error
    end

    it 'does not raise validation issues when URLs are empty strings' do
      expect {empty_website.save!}.to_not raise_error
    end
  end

  context 'adding charity superadmins by email' do
    it 'handles an invalid email with an error' do
      @org1.update_attributes_with_superadmin({:superadmin_email_to_add => 'user'})
      expect(@org1.errors.messages[:superadministrator_email]).to include "The user email you entered,'user', is invalid"
    end
    it 'does not email when email is invalid' do
      expect{
        @org1.update_attributes_with_superadmin({:superadmin_email_to_add => 'user'})
      }.not_to change(ActionMailer::Base.deliveries, :length)
    end
    it 'does not update other attributes when email is invalid' do
      @org1.update_attributes_with_superadmin({:superadmin_email_to_add => 'user', :name => 'Random name'})
      expect(@org1.name).not_to eq 'Random name'
    end

    it 'handles a non-existent email by inviting user' do
      expect(@org1.update_attributes_with_superadmin({:superadmin_email_to_add => 'nonexistentuser@example.com'})).to be true
      expect(@org1).to be_valid
      usr = User.find_by(email:'nonexistentuser@example.com')
      expect(usr).not_to be_nil
      expect(usr.organisation).to eq @org1
    end
    it 'does not update other attributes when there is an invalid email' do
      expect(@org1.update_attributes_with_superadmin({:name => 'New name',:superadmin_email_to_add => 'user'})).to be_nil
      expect(@org1.name).not_to eq 'New name'
    end
    it 'handles a nil email' do
      expect(@org1.update_attributes_with_superadmin({:superadmin_email_to_add => nil})).to be true
      expect(@org1.errors.any?).to be false
    end
    it 'handles a blank email' do
      expect(@org1.update_attributes_with_superadmin({:superadmin_email_to_add => ''})).to be true
      expect(@org1.errors.any?).to be false
    end
    it 'adds existent user as charity superadmin' do
      usr = FactoryGirl.create(:user, :email => 'user@example.org')
      expect(@org1.update_attributes_with_superadmin({:superadmin_email_to_add => usr.email})).to be true
      expect(@org1.users).to include usr
    end
    it 'uses org admin mailer to email existent user when upgraded to org admin' do
      usr = FactoryGirl.create(:user, :email => 'user@example.org')
      mockMessage = double('message')
      expect(mockMessage).to receive :deliver_now
      expect(OrgAdminMailer).to receive_message_chain(:new_org_admin).with(@org1, [usr.email]).and_return(mockMessage)
      @org1.update_attributes_with_superadmin({:superadmin_email_to_add => usr.email})
    end
    it 'updates other attributes with blank email' do
      expect(@org1.update_attributes_with_superadmin({:name => 'New name',:superadmin_email_to_add => ''})).to be true
      expect(@org1.name).to eq 'New name'
    end
    it 'updates other attributes with valid email' do
      usr = FactoryGirl.create(:user, :email => 'user@example.org')
      expect(@org1.update_attributes_with_superadmin({:name => 'New name',:superadmin_email_to_add => usr.email})).to be true
      expect(@org1.name).to eq 'New name'
    end
  end

  it 'should have and belong to many categories' do
    expect(@org2.categories).to include(@category1)
    expect(@org2.categories).to include(@category2)
  end

  it 'should have and belong to many categories by types' do
    expect(@org2.categories.what_they_do).to include(@category3)
    expect(@org2.categories.who_they_help).to include(@category1)
    expect(@org2.categories.how_they_help).to include(@category2)
  end

  it 'must have search by keyword' do
    expect(Organisation).to respond_to(:search_by_keyword)
  end

  it 'find all orgs that have keyword anywhere in their name or description' do
    expect(Organisation.search_by_keyword('elderly')).to eq([@org2, @org3])
  end

  it 'has users' do
    expect(@org1).to respond_to(:users)
  end

  it 'can humanize with all first capitals' do
    expect('HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW'.humanized_all_first_capitals).to eq('Harrow Baptist Church, College Road, Harrow')
  end

  describe 'Creating of Organisations from CSV file' do
    before(:each) do
      allow_any_instance_of(Organisation).to receive(:geocode)
      @headers = 'Title,Charity Number,Activities,Contact Name,Contact Address,website,Contact Telephone,date registered,date removed,accounts date,spending,income,company number,OpenlyLocalURL,twitter account name,facebook account name,youtube account name,feed url,Charity Classification,signed up for 1010,last checked,created at,updated at,Removed?'.split(',')
    end
    it 'must not override an existing organisation' do
      fields = CSV.parse('INDIAN ELDERS ASSOCIATION,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH,COLLEGE ROAD, HARROW, HA1 4HZ",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      org = create_organisation(fields)
      expect(org).to be_nil
    end

    it 'must not create org when date removed is not nil' do
      fields = CSV.parse('HARROW BAPTIST CHURCH,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,2009-05-28,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      org = create_organisation(fields)
      expect(org).to be_nil
    end

    it 'must be able to generate multiple Organisations from text file' do
      expect{
        Organisation.import_addresses 'db/data.csv', 2
      }.to change(Organisation, :count).by 2
    end

    it 'must fail gracefully when encountering error in generating multiple Organisations from text file' do
      allow(Organisation).to receive(:sleep)
      attempted_number_to_import = 1006
      actual_number_to_import = 642
      allow(Organisation).to receive(:create_from_array).and_raise(CSV::MalformedCSVError)
      expect(lambda {
        Organisation.import_addresses 'db/data.csv', attempted_number_to_import
      }).to change(Organisation, :count).by(0)
    end

    it 'must be able to handle no postcode in text representation' do
      fields = CSV.parse('HARROW BAPTIST CHURCH,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      org = create_organisation(fields)
      expect(org.name).to eq('Harrow Baptist Church')
      expect(org.description).to eq('No information recorded')
      expect(org.address).to eq('Harrow Baptist Church, College Road, Harrow')
      expect(org.postcode).to eq('No information recorded')
      expect(org.website).to eq('http://www.harrow-baptist.org.uk')
      expect(org.telephone).to eq('020 8863 7837')
      expect(org.donation_info).to eq("")
    end

    it 'must be able to handle no address in text representation' do
      fields = CSV.parse('HARROW BAPTIST CHURCH,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,,http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      org = create_organisation(fields)
      expect(org.name).to eq('Harrow Baptist Church')
      expect(org.description).to eq('No information recorded')
      expect(org.address).to eq('No information recorded')
      expect(org.postcode).to eq('No information recorded')
      expect(org.website).to eq('http://www.harrow-baptist.org.uk')
      expect(org.telephone).to eq('020 8863 7837')
      expect(org.donation_info).to eq("")
    end

    it 'must be able to generate Organisation from text representation ensuring words in correct case and postcode is extracted from address' do
      fields = CSV.parse('HARROW BAPTIST CHURCH,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW, HA1 4HZ",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      org = create_organisation(fields)
      expect(org.name).to eq('Harrow Baptist Church')
      expect(org.description).to eq('No information recorded')
      expect(org.address).to eq('Harrow Baptist Church, College Road, Harrow')
      expect(org.postcode).to eq('HA1 4HZ')
      expect(org.website).to eq('http://www.harrow-baptist.org.uk')
      expect(org.telephone).to eq('020 8863 7837')
      expect(org.donation_info).to eq("")
    end


    it 'should raise error if no columns found' do
      #Headers are without Title header
      @headers = 'Charity Number,Activities,Contact Name,Contact Address,website,Contact Telephone,date registered,date removed,accounts date,spending,income,company number,OpenlyLocalURL,twitter account name,facebook account name,youtube account name,feed url,Charity Classification,signed up for 1010,last checked,created at,updated at,Removed?'.split(',')
      fields = CSV.parse('HARROW BAPTIST CHURCH,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW, HA1 4HZ",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      expect(lambda{
        org = create_organisation(fields)
      }).to raise_error CSV::MalformedCSVError
    end

    it 'should be able to substitute with empty string when data is missing' do
      attributes = {name: '',
                    address: '',
                    description: '',
                    postcode: '',
                    website: '',
                    telephone: ''}
      expect { Organisation.create_and_substitute_with_empty attributes }.not_to raise_error
    end

    def create_organisation(fields)
      row = CSV::Row.new(@headers, fields.flatten)
      Organisation.create_from_array(row, true)
    end

    context "importing category relations" do
      let(:fields) do
        CSV.parse('HARROW BEREAVEMENT COUNSELLING,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW, HA1 4HZ",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      end
      let(:row) do
        CSV::Row.new(@headers, fields.flatten)
      end
      let(:fields_cat_missing) do
        CSV.parse('HARROW BEREAVEMENT COUNSELLING,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW, HA1 4HZ",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,,false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      end
      let(:row_cat_missing) do
        CSV::Row.new(@headers, fields_cat_missing.flatten)
      end
      it 'must be able to avoid org category relations from text file when org does not exist' do
        @org4 = FactoryGirl.build(:organisation, :name => 'Fellowship For Management In Food Distribution', :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 4HZ', :donation_info => 'www.harrow-bereavment.co.uk/donate')
        @org4.save!
        [102,206,302].each do |id|
          FactoryGirl.build(:category, :charity_commission_id => id).save!
        end
        attempted_number_to_import = 2
        number_cat_org_relations_generated = 3
        expect(lambda {
          Organisation.import_category_mappings 'db/data.csv', attempted_number_to_import
        }).to change(CategoryOrganisation, :count).by(number_cat_org_relations_generated)
      end

      it "allows us to import categories" do
        org = Organisation.import_categories_from_array(row)
        expect(org.categories.length).to eq 5
        [207,305,108,302,306].each do |id|
          expect(org.categories).to include(Category.find_by_charity_commission_id(id))
        end
      end

      it 'must fail gracefully when encountering error in importing categories from text file' do
        attempted_number_to_import = 2
        allow(Organisation).to receive(:import_categories_from_array).and_raise(CSV::MalformedCSVError)
        expect(lambda {
          Organisation.import_category_mappings 'db/data.csv', attempted_number_to_import
        }).to change(Organisation, :count).by(0)
      end

      it "should import categories when matching org is found" do
        expect(Organisation).to receive(:check_columns_in).with(row)
        expect(Organisation).to receive(:find_by_name).with('Harrow Bereavement Counselling').and_return @org1
        array = double('Array')
        [{:cc_id => 207, :cat => @cat1}, {:cc_id => 305, :cat => @cat2}, {:cc_id => 108, :cat => @cat3},
         {:cc_id => 302, :cat => @cat4}, {:cc_id => 306, :cat => @cat5}]. each do |cat_hash|
          expect(Category).to receive(:find_by_charity_commission_id).with(cat_hash[:cc_id]).and_return(cat_hash[:cat])
          expect(array).to receive(:<<).with(cat_hash[:cat])
        end
        expect(@org1).to receive(:categories).exactly(5).times.and_return(array)
        org = Organisation.import_categories_from_array(row)
        expect(org).not_to be_nil
      end

      it "should not import categories when no matching organisation" do
        expect(Organisation).to receive(:check_columns_in).with(row)
        expect(Organisation).to receive(:find_by_name).with('Harrow Bereavement Counselling').and_return nil
        org = Organisation.import_categories_from_array(row)
        expect(org).to be_nil
      end

      it "should not import categories when none are listed" do
        expect(Organisation).to receive(:check_columns_in).with(row_cat_missing)
        expect(Organisation).to receive(:find_by_name).with('Harrow Bereavement Counselling').and_return @org1
        org = Organisation.import_categories_from_array(row_cat_missing)
        expect(org).not_to be_nil
      end
    end
  end

  # not sure if we need SQL injection security tests like this ...
  # org = Organisation.new(:address =>"blah", :gmaps=> ";DROP DATABASE;")
  # org = Organisation.new(:address =>"blah", :name=> ";DROP DATABASE;")

  describe "importing emails" do
    it "should have a method import_emails" do
      filename = "db/emails.csv"
      expect(Organisation).to receive(:add_email).twice.and_call_original
      expect(Organisation).to receive(:import).with(filename,2,false).and_call_original
     # do |&arg|
     #   byebug
     #   Organisation.add_email(&arg)
     # end
      Organisation.import_emails(filename,2,false)
    end

    it 'should handle absence of org gracefully' do
      expect(Organisation).to receive(:where).with("UPPER(name) LIKE ? ", "%I LOVE PEOPLE%").and_return(nil)
      expect(lambda{
        response = Organisation.add_email(fields = CSV.parse('i love people,,,,,,,test@example.org')[0],true)
        expect(response).to eq "i love people was not found\n"
      }).not_to raise_error
    end

    it "should add email to org" do
      expect(Organisation).to receive(:where).with("UPPER(name) LIKE ? ", "%FRIENDLY%").and_return([@org1])
      expect(@org1).to receive(:email=).with('test@example.org')
      expect(@org1).to receive(:save)
      Organisation.add_email(fields = CSV.parse('friendly,,,,,,,test@example.org')[0],true)
    end

    it "should add blank string email to org if email is NULL" do
      expect(Organisation).to receive(:where).with("UPPER(name) LIKE ? ", "%FRIENDLY%").and_return([@org1])
      expect{
        Organisation.add_email(fields = CSV.parse('friendly,,,,,,,')[0],true)
      }.not_to change(@org1, :email)
    end

    it "should add email to org even with case mismatch" do
      expect(Organisation).to receive(:where).with("UPPER(name) LIKE ? ", "%FRIENDLY%").and_return([@org1])
      expect(@org1).to receive(:email=).with('test@example.org')
      expect(@org1).to receive(:save)
      Organisation.add_email(fields = CSV.parse('friendly,,,,,,,test@example.org')[0],true)
    end

    it 'should not add email to org when it has an existing email' do
      @org1.email = 'something@example.com'
      @org1.save!
      expect(Organisation).to receive(:where).with("UPPER(name) LIKE ? ", "%FRIENDLY%").and_return([@org1])
      expect(@org1).not_to receive(:email=).with('test@example.org')
      expect(@org1).not_to receive(:save)
      Organisation.add_email(fields = CSV.parse('friendly,,,,,,,test@example.org')[0],true)
    end
  end
  
  describe 'destroy uses acts_as_paranoid' do
    it 'can be recovered' do
      @org1.destroy
      expect(Organisation.find_by_name('Harrow Bereavement Counselling')).to eq nil
      Organisation.with_deleted.find_by_name('Harrow Bereavement Counselling').restore
      expect(Organisation.find_by_name('Harrow Bereavement Counselling')).to eq @org1
    end
  end

  describe '#uninvite_users' do
    let!(:current_user) { FactoryGirl.create(:user, email: 'superadmin@example.com', superadmin: true) }
    let(:org) { FactoryGirl.create :organisation, email: 'YES@hello.com' }
    let(:params) do
      {invite_list: {org.id => org.email,
                     org.id+1 => org.email},
                     resend_invitation: false}
    end
    let(:invited_user) { User.where("users.organisation_id IS NOT null").first }

    before do
      BatchInviteJob.new(params, current_user).run
      expect(invited_user.organisation_id).to eq org.id
    end

    it "unsets user-organisation association of users of the organisation that"\
       "are invited_not_accepted" do
      expect{
        org.uninvite_users
        invited_user.reload
      }.to change(invited_user, :organisation_id).from(org.id).to(nil)
    end

    it "happens when email is updated" do
      expect{
        org.update_attributes(email: 'hello@email.com')
        invited_user.reload
      }.to change(invited_user, :organisation_id).from(org.id).to(nil)
    end

    it "doesn't happen when other attributes are updated" do
      expect{
        org.update_attributes(website: 'www.abc.com')
        invited_user.reload
      }.not_to change(invited_user, :organisation_id)
    end
  end

  context "geocoding" do
    describe 'not_geocoded?' do
      it 'should return true if it lacks latitude and longitude' do
        @org1.assign_attributes(latitude: nil, longitude: nil)
        expect(@org1.not_geocoded?).to be true
      end

      it 'should return false if it has latitude and longitude' do
        expect(@org2.not_geocoded?).to be false
      end
    end

    describe 'run_geocode?' do
      it 'should return true if address is changed' do
        @org1.address = "asjkdhas,ba,asda"
        expect(@org1.run_geocode?).to be true
      end

      it 'should return false if address is not changed' do
        expect(@org1).to receive(:address_changed?).and_return(false)
        expect(@org1).to receive(:not_geocoded?).and_return(false)
        expect(@org1.run_geocode?).to be false
      end

      it 'should return false if org has no address' do
        org = Organisation.new
        expect(org.run_geocode?).to be false
      end

      it 'should return true if org has an address but no coordinates' do
        expect(@org1).to receive(:not_geocoded?).and_return(true)
        expect(@org1.run_geocode?).to be true
      end

      it 'should return false if org has an address and coordinates' do
        expect(@org2).to receive(:not_geocoded?).and_return(false)
        expect(@org2.run_geocode?).to be false
      end
    end

    describe "acts_as_gmappable's behavior is curtailed by the { :process_geocoding => :run_geocode? } option" do
      it 'no geocoding allowed when saving if the org already has an address and coordinates' do
        expect_any_instance_of(Organisation).not_to receive(:geocode)
        @org2.email = 'something@example.com'
        @org2.save!
      end

      # it will try to rerun incomplete geocodes, but not valid ones, so no harm is done
      it 'geocoding allowed when saving if the org has an address BUT NO coordinates' do
        expect_any_instance_of(Organisation).to receive(:geocode)
        @org2.longitude = nil ; @org2.latitude = nil
        @org2.email = 'something@example.com'
        @org2.save!
      end

      it 'geocoding allowed when saving if the org address changed' do
        expect_any_instance_of(Organisation).to receive(:geocode)
        @org2.address = '777 pinner road'
        @org2.save!
      end
    end
  end
end

describe Organisation, :type => :model do

  before do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions

    @org1 = FactoryGirl.build(:organisation, :name => 'Harrow Bereavement Counselling', :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 4HZ', :donation_info => 'www.harrow-bereavment.co.uk/donate')
    @org1.save!
    @org2 = FactoryGirl.build(:organisation, :name => 'Indian Elders Associaton', :description => 'Care for the elderly', :address => '64 pinner road', :postcode => 'HA1 4HZ', :latitude => 77, :longitude => 77, :donation_info => 'www.indian-elders.co.uk/donate')
    @org2.save!
    @org3 = FactoryGirl.build(:organisation, :name => 'Age UK Elderly', :description => 'Care for older people', :address => '64 pinner road', :postcode => 'HA1 4HZ', :donation_info => 'www.age-uk.co.uk/donate')
    @org3.save!
  end
  
  describe 'not_geocoded?' do
    it 'should return true if it lacks latitude and longitude' do
      @org1.assign_attributes(latitude: nil, longitude: nil)
      expect(@org1.not_geocoded?).to be true
    end

    it 'should return false if it has latitude and longitude' do
      expect(@org2.not_geocoded?).to be false
    end
  end

  describe 'run_geocode?' do
    it 'should return true if address is changed' do
      @org1.address = "asjkdhas,ba,asda"
      expect(@org1.run_geocode?).to be true
    end

    it 'should return false if address is not changed' do
      expect(@org1).to receive(:address_changed?).and_return(false)
      expect(@org1).to receive(:not_geocoded?).and_return(false)
      expect(@org1.run_geocode?).to be false
    end

    it 'should return false if org has no address' do
      org = Organisation.new
      expect(org.run_geocode?).to be false
    end

    it 'should return true if org has an address but no coordinates' do
      expect(@org1).to receive(:not_geocoded?).and_return(true)
      expect(@org1.run_geocode?).to be true
    end

    it 'should return false if org has an address and coordinates' do
      expect(@org2).to receive(:not_geocoded?).and_return(false)
      expect(@org2.run_geocode?).to be false
    end
  end

  describe "acts_as_gmappable's behavior is curtailed by the { :process_geocoding => :run_geocode? } option" do
    it 'no geocoding allowed when saving if the org already has an address and coordinates' do
      expect_any_instance_of(Organisation).not_to receive(:geocode)
      @org2.email = 'something@example.com'
      @org2.save!
    end

    # it will try to rerun incomplete geocodes, but not valid ones, so no harm is done
    it 'geocoding allowed when saving if the org has an address BUT NO coordinates' do
      expect_any_instance_of(Organisation).to receive(:geocode)
      @org2.longitude = nil ; @org2.latitude = nil
      @org2.email = 'something@example.com'
      @org2.save!
    end

    it 'geocoding allowed when saving if the org address changed' do
      expect_any_instance_of(Organisation).to receive(:geocode)
      @org2.address = '777 pinner road'
      @org2.save!
    end
  end
end

describe Organisation, '::filter_by_categories' do
  let!(:category1) { create(:category, :charity_commission_id => 108) }
  let!(:category2) { create(:category, :charity_commission_id => 205) }
  # not initialized!
  let(:category3) { create(:category, :charity_commission_id => 307) }

  let!(:org1) do
    create(
      :organisation,
      :email => "",
      :name => 'Harrow Bereavement Counselling',
      :description => 'Bereavement Counselling',
      :address => '64 pinner road',
      :postcode => 'HA1 4HZ',
      :donation_info => 'www.harrow-bereavment.co.uk/donate',
    )
  end

  let!(:org2) do
    create(
      :organisation,
      :name => 'Indian Elders Association',
      :email => "",
      :description => 'Care for the elderly',
      :address => '64 pinner road',
      :postcode => 'HA1 4HZ',
      :donation_info => 'www.indian-elders.co.uk/donate'
    ).tap { |o| o.categories << category1 ; o.categories << category2 }
  end

  let!(:org3) do
    create(
      :organisation,
      :email => "",
      :name => 'Age UK Elderly',
      :description => 'Care for older people',
      :address => '64 pinner road',
      :postcode => 'HA1 4HZ',
      :donation_info => 'www.age-uk.co.uk/donate',
    ).tap { |o| o.categories  << category1 }
  end

  context 'when filtering by ONE CATEGORY, it returns only organisations that
           \ are associated with that category' do

    it 'organisations returned by query' do
      expect(
        Organisation.filter_by_categories([category1.id]).pluck(:id)
      ).to include(
        org2.id, org3.id
      )
    end

    it 'no duplicates' do
      expect(
        Organisation.filter_by_categories([category1.id]).map.size
      ).to eq 2
    end

    it 'categories in join table' do
      expect(
        CategoryOrganisation.where(
          organisation_id: Organisation.filter_by_categories([category1.id]).select(:id)
        ).pluck(:category_id).uniq
      ).to include(
        category1.id, category2.id
      )
    end
  end

  context 'when filtering by TWO CATEGORIES, it returns only organisations that
           \ are associated with those categories' do
    # init
    before { category3 }

    it 'organisations returned by query' do
      expect(
        Organisation.filter_by_categories([
          category1.id,
          category2.id,
        ]).pluck(:id)
      ).to include(
        org2.id
      )
    end

    it 'no duplicates' do
      expect(
        Organisation.filter_by_categories([
          category1.id,
          category2.id,
        ]).map.size
      ).to eq 1
    end

    it 'categories in join table' do
      expect(
        CategoryOrganisation.where(
          organisation_id: Organisation.filter_by_categories([
            category1.id,
            category2.id,
          ]).select(:id)
        ).pluck(:category_id).uniq
      ).to include(
        category1.id, category2.id
      )
    end
  end

end
