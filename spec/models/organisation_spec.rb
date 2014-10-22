require 'spec_helper'

describe Organisation do

  before do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions

    @category1 = FactoryGirl.create(:category, :charity_commission_id => 207)
    @category2 = FactoryGirl.create(:category, :charity_commission_id => 305)
    @category3 = FactoryGirl.create(:category, :charity_commission_id => 108)
    @category4 = FactoryGirl.create(:category, :charity_commission_id => 302)
    @category5 = FactoryGirl.create(:category, :charity_commission_id => 306)
    @org1 = FactoryGirl.build(:organisation, :name => 'Harrow Bereavement Counselling', :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 3TE', :donation_info => 'www.harrow-bereavment.co.uk/donate')
    Gmaps4rails.stub(:geocode => nil)
    @org1.save!
    @org2 = FactoryGirl.build(:organisation, :name => 'Indian Elders Association',
                              :description => 'Care for the elderly', :address => '62 pinner road', :postcode => 'HA1 3RE', :donation_info => 'www.indian-elders.co.uk/donate')
    @org2.categories << @category1
    @org2.categories << @category2
    @org2.save!
    @org3 = FactoryGirl.build(:organisation, :name => 'Age UK Elderly', :description => 'Care for older people', :address => '62 pinner road', :postcode => 'HA1 3RE', :donation_info => 'www.age-uk.co.uk/donate')
    @org3.categories << @category1
    @org3.save!
  end
  describe "#gmaps4rails_marker_picture" do

    context 'no user' do
      it 'returns small icon when no associated user' do
        expect(@org1.gmaps4rails_marker_picture).to eq({"picture" => "/assets/org_icon_small.png"})
      end
   end

    context 'has user' do
      before(:each) do
        usr = FactoryGirl.create(:user, :email => "orgadmin@org.org")
        usr.confirm!
        @org1.users << [usr]
        @org1.save!
      end
    it 'returns large icon when there is an associated user' do
      expect(@org1.gmaps4rails_marker_picture).to eq({"picture" => "/assets/org_icon_large.png"})
    end

     it 'returns small icon when there is an associated user but update is too old' do
        future_time = Time.at(Time.now + 2.month)
        Time.stub(:now){future_time}
        expect(@org1.gmaps4rails_marker_picture).to eq({"picture" => "/assets/org_icon_small.png"})
        allow(Time).to receive(:now).and_call_original
     end
    end
  end
  context 'scopes for orphan orgs' do
    before(:each) do
      @user = FactoryGirl.create(:user, :email => "hello@hello.com")
      @user.confirm!
    end

    it 'should allow us to grab orgs with emails' do
      Organisation.not_null_email.should eq []
      @org1.email = "hello@hello.com"
      @org1.save
      Organisation.not_null_email.should eq [@org1]
    end

    it 'should allow us to grab orgs with no admin' do
      Organisation.null_users.sort.should eq [@org1, @org2, @org3].sort
      @org1.email = "hello@hello.com"
      @org1.save
      @user.confirm!
      @org1.users.should eq [@user]
      Organisation.null_users.sort.should eq [@org2, @org3].sort
    end

    it 'should allow us to exclude previously invited users' do
      @org1.email = "hello@hello.com"
      @org1.save
      Organisation.without_matching_user_emails.should_not include @org1
    end

    # Should we have more tests to cover more possible combinations?
    it 'should allow us to combine scopes' do
      @org1.email = "hello@hello.com"
      @org1.save
      @org3.email = "hello_again@you_again.com"
      @org3.save
      Organisation.null_users.not_null_email.sort.should eq [@org1, @org3]
      Organisation.null_users.not_null_email.without_matching_user_emails.sort.should eq [@org3]
    end
  end

  context 'validating URLs' do
    subject(:no_http_org) { FactoryGirl.build(:organisation, :name => 'Harrow Bereavement Counselling', :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 3TE', :donation_info => 'www.harrow-bereavment.co.uk/donate') }
    subject(:empty_website)  {FactoryGirl.build(:organisation, :name => 'Harrow Bereavement Counselling', :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 3TE', :donation_info => '', :website => '')}
    it 'if lacking protocol, http is prefixed to URL when saved' do
      no_http_org.save!
      no_http_org.donation_info.should include('http://')
    end

    it 'a URL is left blank, no validation issues arise' do
      expect {no_http_org.save! }.to_not raise_error
    end

    it 'does not raise validation issues when URLs are empty strings' do
      expect {empty_website.save!}.to_not raise_error
    end
  end

  context 'adding charity admins by email' do
    it 'handles a non-existent email with an error' do
      expect(@org1.update_attributes_with_admin({:admin_email_to_add => 'nonexistentuser@example.com'})).to be_false
      expect(@org1.errors[:administrator_email]).to eq ["The user email you entered,'nonexistentuser@example.com', does not exist in the system"]
    end
    it 'does not update other attributes when there is a non-existent email' do
      expect(@org1.update_attributes_with_admin({:name => 'New name',:admin_email_to_add => 'nonexistentuser@example.com'})).to be_false
      expect(@org1.name).not_to eq 'New name'
    end
    it 'handles a nil email' do
      expect(@org1.update_attributes_with_admin({:admin_email_to_add => nil})).to be_true
      expect(@org1.errors.any?).to be_false
    end
    it 'handles a blank email' do
      expect(@org1.update_attributes_with_admin({:admin_email_to_add => ''})).to be_true
      expect(@org1.errors.any?).to be_false
    end
    it 'adds existent user as charity admin' do
      usr = FactoryGirl.create(:user, :email => 'user@example.org')
      expect(@org1.update_attributes_with_admin({:admin_email_to_add => usr.email})).to be_true
      expect(@org1.users).to include usr
    end
    it 'updates other attributes with blank email' do
      expect(@org1.update_attributes_with_admin({:name => 'New name',:admin_email_to_add => ''})).to be_true
      expect(@org1.name).to eq 'New name'
    end
    it 'updates other attributes with valid email' do
      usr = FactoryGirl.create(:user, :email => 'user@example.org')
      expect(@org1.update_attributes_with_admin({:name => 'New name',:admin_email_to_add => usr.email})).to be_true
      expect(@org1.name).to eq 'New name'
    end
  end
  it 'responds to filter by category' do
    expect(Organisation).to respond_to(:filter_by_category)
  end

  it 'finds all orgs in a particular category' do
    expect(Organisation.filter_by_category(@category1.id)).not_to include @org1
    expect(Organisation.filter_by_category(@category1.id)).to include @org2
    expect(Organisation.filter_by_category(@category1.id)).to include @org3
  end

  it 'finds all orgs when category is nil, and returns ActiveRecord::Relation to keep kaminari happy' do
    expect(Organisation.filter_by_category(nil)).to include(@org1)
    expect(Organisation.filter_by_category(nil)).to include(@org2)
    expect(Organisation.filter_by_category(nil)).to include(@org3)
    expect(Organisation.filter_by_category(nil).class).to eq ActiveRecord::Relation
  end

  it 'should have and belong to many categories' do
    expect(@org2.categories).to include(@category1)
    expect(@org2.categories).to include(@category2)
  end

  it 'must have search by keyword' do
    expect(Organisation).to respond_to(:search_by_keyword)
  end

  it 'find all orgs that have keyword anywhere in their name or description' do
    expect(Organisation.search_by_keyword("elderly")).to eq([@org2, @org3])
  end

  it 'searches by keyword and filters by category and has zero results' do
    result = Organisation.search_by_keyword("Harrow").filter_by_category("1")
    expect(result).not_to include @org1, @org2, @org3
  end

  it 'searches by keyword and filters by category and has results' do
    result = Organisation.search_by_keyword("Indian").filter_by_category(@category1.id)
    expect(result).to include @org2
    expect(result).not_to include @org1, @org3
  end

  it 'searches by keyword when filter by category id is nil' do
    result = Organisation.search_by_keyword("Harrow").filter_by_category(nil)
    expect(result).to include @org1
    expect(result).not_to include @org2, @org3
  end

  it 'filters by category when searches by keyword is nil' do
    result = Organisation.search_by_keyword(nil).filter_by_category(@category1.id)
    expect(result).to include @org2, @org3
    expect(result).not_to include @org1
  end

  it 'returns all orgs when both filter by category and search by keyword are nil args' do
    result = Organisation.search_by_keyword(nil).filter_by_category(nil)
    expect(result).to include @org1, @org2, @org3
  end

  it 'handles weird input (possibly from infinite scroll system)' do
    # Couldn't find Category with id=?test=0
    expect(lambda {Organisation.filter_by_category("?test=0")} ).not_to raise_error
  end

  it 'has users' do
    expect(@org1).to respond_to(:users)
  end

  it 'can humanize with all first capitals' do
    expect("HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW".humanized_all_first_capitals).to eq("Harrow Baptist Church, College Road, Harrow")
  end

  describe 'Creating of Organisations from CSV file' do
    before(:all){ @headers = 'Title,Charity Number,Activities,Contact Name,Contact Address,website,Contact Telephone,date registered,date removed,accounts date,spending,income,company number,OpenlyLocalURL,twitter account name,facebook account name,youtube account name,feed url,Charity Classification,signed up for 1010,last checked,created at,updated at,Removed?'.split(',')}

    it 'must not override an existing organisation' do
      fields = CSV.parse('INDIAN ELDERS ASSOCIATION,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH,COLLEGE ROAD, HARROW, HA1 1BA",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      org = create_organisation(fields)
      expect(org).to be_nil
    end

    it 'must not create org when date removed is not nil' do
      fields = CSV.parse('HARROW BAPTIST CHURCH,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,2009-05-28,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      org = create_organisation(fields)
      expect(org).to be_nil
    end

    # the following 6 or so feel more like integration tests than unit tests
    # TODO should they be moved into another file?  OR MAYBE TO CUCUMBER???
    it 'must be able to generate multiple Organisations from text file' do
      mock_org = double("org")
      [:name, :name=, :description=, :address=, :postcode=, :website=, :telephone=].each do |method|
        mock_org.stub(method)
      end
      Organisation.stub(:find_by_name).and_return nil
      attempted_number_to_import = 1006
      actual_number_to_import = 642
      time = Time.now
      Organisation.should_receive(:new).exactly(actual_number_to_import).and_return mock_org
      rows_to_parse = (1..attempted_number_to_import).collect do |number|
          hash_to_return = {}
          hash_to_return.stub(:header?){true}
          hash_to_return[Organisation.column_mappings[:name]] = "Test org #{number}"
          hash_to_return[Organisation.column_mappings[:address]] = "10 Downing St London SW1A 2AA, United Kingdom"
        if(actual_number_to_import < number)
           hash_to_return[Organisation.column_mappings[:date_removed]] = time
        end

        hash_to_return
      end
      mock_file_handle = double("file")
      File.should_receive(:open).and_return(mock_file_handle)
      CSV.should_receive(:parse).with(mock_file_handle, :headers => true).and_return rows_to_parse
      mock_org.should_receive(:save!).exactly(actual_number_to_import)
      Organisation.import_addresses 'db/data.csv', attempted_number_to_import

    end

    it 'must fail gracefully when encountering error in generating multiple Organisations from text file' do
      attempted_number_to_import = 1006
      actual_number_to_import = 642
      Gmaps4rails.should_receive(:geocode).exactly(0)
      Organisation.stub(:create_from_array).and_raise(CSV::MalformedCSVError)
      expect(lambda {
        Organisation.import_addresses 'db/data.csv', attempted_number_to_import
      }).to change(Organisation, :count).by(0)
    end

    it 'must be able to handle no postcode in text representation' do
      Gmaps4rails.should_receive(:geocode)
      fields = CSV.parse('HARROW BAPTIST CHURCH,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      org = create_organisation(fields)
      expect(org.name).to eq('Harrow Baptist Church')
      expect(org.description).to eq('No information recorded')
      expect(org.address).to eq('Harrow Baptist Church, College Road, Harrow')
      expect(org.postcode).to eq('')
      expect(org.website).to eq('http://www.harrow-baptist.org.uk')
      expect(org.telephone).to eq('020 8863 7837')
      expect(org.donation_info).to eq(nil)
    end

    it 'must be able to handle no address in text representation' do
      Gmaps4rails.should_receive(:geocode)
      fields = CSV.parse('HARROW BAPTIST CHURCH,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,,http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      org = create_organisation(fields)
      expect(org.name).to eq('Harrow Baptist Church')
      expect(org.description).to eq('No information recorded')
      expect(org.address).to eq('')
      expect(org.postcode).to eq('')
      expect(org.website).to eq('http://www.harrow-baptist.org.uk')
      expect(org.telephone).to eq('020 8863 7837')
      expect(org.donation_info).to eq(nil)
    end

    it 'must be able to generate Organisation from text representation ensuring words in correct case and postcode is extracted from address' do
      Gmaps4rails.should_receive(:geocode)
      fields = CSV.parse('HARROW BAPTIST CHURCH,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW, HA1 1BA",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      org = create_organisation(fields)
      expect(org.name).to eq('Harrow Baptist Church')
      expect(org.description).to eq('No information recorded')
      expect(org.address).to eq('Harrow Baptist Church, College Road, Harrow')
      expect(org.postcode).to eq('HA1 1BA')
      expect(org.website).to eq('http://www.harrow-baptist.org.uk')
      expect(org.telephone).to eq('020 8863 7837')
      expect(org.donation_info).to eq(nil)
    end


    it 'should raise error if no columns found' do
      #Headers are without Title header
      @headers = 'Charity Number,Activities,Contact Name,Contact Address,website,Contact Telephone,date registered,date removed,accounts date,spending,income,company number,OpenlyLocalURL,twitter account name,facebook account name,youtube account name,feed url,Charity Classification,signed up for 1010,last checked,created at,updated at,Removed?'.split(',')
      fields = CSV.parse('HARROW BAPTIST CHURCH,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW, HA1 1BA",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      expect(lambda{
        org = create_organisation(fields)
      }).to raise_error
    end


    def create_organisation(fields)
      row = CSV::Row.new(@headers, fields.flatten)
      Organisation.create_from_array(row, true)
    end

    context "importing category relations" do
      let(:fields) do
        CSV.parse('HARROW BEREAVEMENT COUNSELLING,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW, HA1 1BA",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      end
      let(:row) do
        CSV::Row.new(@headers, fields.flatten)
      end
      let(:fields_cat_missing) do
        CSV.parse('HARROW BEREAVEMENT COUNSELLING,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW, HA1 1BA",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,,false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      end
      let(:row_cat_missing) do
        CSV::Row.new(@headers, fields_cat_missing.flatten)
      end
      it 'must be able to avoid org category relations from text file when org does not exist' do
        @org4 = FactoryGirl.build(:organisation, :name => 'Fellowship For Management In Food Distribution', :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 3TE', :donation_info => 'www.harrow-bereavment.co.uk/donate')
        Gmaps4rails.should_receive(:geocode)
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
        Organisation.stub(:import_categories_from_array).and_raise(CSV::MalformedCSVError)
        expect(lambda {
          Organisation.import_category_mappings 'db/data.csv', attempted_number_to_import
        }).to change(Organisation, :count).by(0)
      end

      it "should import categories when matching org is found" do
        Organisation.should_receive(:check_columns_in).with(row)
        Organisation.should_receive(:find_by_name).with('Harrow Bereavement Counselling').and_return @org1
        array = double('Array')
        [{:cc_id => 207, :cat => @cat1}, {:cc_id => 305, :cat => @cat2}, {:cc_id => 108, :cat => @cat3},
         {:cc_id => 302, :cat => @cat4}, {:cc_id => 306, :cat => @cat5}]. each do |cat_hash|
          Category.should_receive(:find_by_charity_commission_id).with(cat_hash[:cc_id]).and_return(cat_hash[:cat])
          array.should_receive(:<<).with(cat_hash[:cat])
        end
        @org1.should_receive(:categories).exactly(5).times.and_return(array)
        org = Organisation.import_categories_from_array(row)
        expect(org).not_to be_nil
      end

      it "should not import categories when no matching organisation" do
        Organisation.should_receive(:check_columns_in).with(row)
        Organisation.should_receive(:find_by_name).with('Harrow Bereavement Counselling').and_return nil
        org = Organisation.import_categories_from_array(row)
        expect(org).to be_nil
      end

      it "should not import categories when none are listed" do
        Organisation.should_receive(:check_columns_in).with(row_cat_missing)
        Organisation.should_receive(:find_by_name).with('Harrow Bereavement Counselling').and_return @org1
        org = Organisation.import_categories_from_array(row_cat_missing)
        expect(org).not_to be_nil
      end
    end
  end


  it 'offers information for the gmap4rails info window' do
    expect(@org1.gmaps4rails_infowindow).to eq(@org1.name)
  end
  
  it 'should have gmaps4rails_option hash with :check_process set to false' do
    expect(@org1.gmaps4rails_options[:check_process]).to be_false
  end

  it 'should geocode when address changes' do
    new_address = '60 pinner road'
    Gmaps4rails.should_receive(:geocode).with("#{new_address}, #{@org1.postcode}", "en", false,"http")
    @org1.update_attributes :address => new_address
  end

  it 'should geocode when new object is created' do
    address = '60 pinner road'
    postcode = 'HA1 3RE'
    Gmaps4rails.should_receive(:geocode).with("#{address}, #{postcode}", "en", false, "http")
    org = FactoryGirl.build(:organisation,:address => address, :postcode => postcode, :name => 'Happy and Nice', :gmaps => true)
    org.save
  end

  #TODO: refactor with expect{} instead of should as Rspec 2 promotes
  it 'should delete geocoding errors and save organisation' do
    new_address = '777 pinner road'
    @org1.latitude = 77
    @org1.longitude = 77
    Gmaps4rails.should_receive(:geocode).and_raise(Gmaps4rails::GeocodeInvalidQuery)
    @org1.address = new_address
    @org1.update_attributes :address => new_address
    @org1.errors['gmaps4rails_address'].should be_empty
    actual_address = Organisation.find_by_name(@org1.name).address
    expect(actual_address).to eq(new_address)
    expect(@org1.latitude).to be_nil
    expect(@org1.longitude).to be_nil
  end

  it 'should not delete validation errors unrelated to gmap4rails address issues' do
    Organisation.class_eval do
      validates :name, :presence => true
    end
    Gmaps4rails.should_receive(:geocode)
    @org1.update_attributes :name => nil
    expect(@org1.errors['name']).not_to be_empty
  end

  it 'should attempt to geocode after failed' do
    Gmaps4rails.should_receive(:geocode).and_raise(Gmaps4rails::GeocodeInvalidQuery)
    @org1.save!
    new_address = '60 pinner road'
    Gmaps4rails.should_receive(:geocode)
    expect(lambda{
      @org1.address = new_address
      # destructive save is called to raise exception if saving fails
      @org1.save!
    }).not_to raise_error
    actual_address = Organisation.find_by_name(@org1.name).address
    expect(actual_address).to eq(new_address)
  end
  # not sure if we need SQL injection security tests like this ...
  # org = Organisation.new(:address =>"blah", :gmaps=> ";DROP DATABASE;")
  # org = Organisation.new(:address =>"blah", :name=> ";DROP DATABASE;")

  describe "importing emails" do
    it "should have a method import_emails" do
      Organisation.should_receive(:add_email)
      Organisation.should_receive(:import).with(nil,2,false) do |&arg|
        Organisation.add_email(&arg)
      end
      Organisation.import_emails(nil,2,false)
    end

    it 'should handle absence of org gracefully' do
      Organisation.should_receive(:where).with("UPPER(name) LIKE ? ", "%I LOVE PEOPLE%").and_return(nil)
      expect(lambda{
        response = Organisation.add_email(fields = CSV.parse('i love people,,,,,,,test@example.org')[0],true)
        response.should eq "i love people was not found\n"
      }).not_to raise_error
    end

    it "should add email to org" do
      Organisation.should_receive(:where).with("UPPER(name) LIKE ? ", "%FRIENDLY%").and_return([@org1])
      @org1.should_receive(:email=).with('test@example.org')
      @org1.should_receive(:save)
      Organisation.add_email(fields = CSV.parse('friendly,,,,,,,test@example.org')[0],true)
    end

    it "should add email to org even with case mismatch" do
      Organisation.should_receive(:where).with("UPPER(name) LIKE ? ", "%FRIENDLY%").and_return([@org1])
      @org1.should_receive(:email=).with('test@example.org')
      @org1.should_receive(:save)
      Organisation.add_email(fields = CSV.parse('friendly,,,,,,,test@example.org')[0],true)
    end

    it 'should not add email to org when it has an existing email' do
      @org1.email = 'something@example.com'
      @org1.save!
      Organisation.should_receive(:where).with("UPPER(name) LIKE ? ", "%FRIENDLY%").and_return([@org1])
      @org1.should_not_receive(:email=).with('test@example.org')
      @org1.should_not_receive(:save)
      Organisation.add_email(fields = CSV.parse('friendly,,,,,,,test@example.org')[0],true)
    end
  end

  describe '#generate_potential_user' do
    let(:org) { @org1 }
    # using a stub_model confuses User.should_receive on line 450 because it's expecting :new from my organisation.rb, but instead the stub_model calls it first
    let(:user) { double('User', {:email => org.email, :password => 'password'}) }

    before :each do
      Devise.stub_chain(:friendly_token, :first).with().with(8).and_return('password')
      User.should_receive(:new).with({:email => org.email, :password => 'password'}).and_return(user)
    end

    it 'early returns a (broken) user when the user is invalid' do
      user.should_receive(:valid?).and_return(false)
      user.should_receive(:save)
    end

    it 'returns a user' do
      user.should_receive(:valid?).and_return(true)
      user.should_receive(:skip_confirmation_notification!)
      User.should_receive(:reset_password_token)
      user.should_receive(:reset_password_token=)
      user.should_receive(:reset_password_sent_at=)
      user.should_receive(:save!)
      user.should_receive(:confirm!)
    end

    after(:each) do
      org.generate_potential_user.should eq(user)
    end
  end

  describe 'destroy uses acts_as_paranoid' do
    it 'can be recovered' do
      @org1.destroy
      expect(Organisation.find_by_name('Harrow Bereavement Counselling')).to eq nil
      Organisation.only_deleted.find_by_name('Harrow Bereavement Counselling').recover
      expect(Organisation.find_by_name('Harrow Bereavement Counselling')).to eq @org1
    end
  end

end
