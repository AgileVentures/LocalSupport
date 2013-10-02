require 'spec_helper'

describe Organization do

  before do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions

    @category1 = FactoryGirl.create(:category, :charity_commission_id => 207)
    @category2 = FactoryGirl.create(:category, :charity_commission_id => 305)
    @category3 = FactoryGirl.create(:category, :charity_commission_id => 108)
    @category4 = FactoryGirl.create(:category, :charity_commission_id => 302)
    @category5 = FactoryGirl.create(:category, :charity_commission_id => 306)
    @org1 = FactoryGirl.build(:organization, :name => 'Harrow Bereavement Counselling', :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 3TE', :donation_info => 'www.harrow-bereavment.co.uk/donate')
    Gmaps4rails.stub(:geocode => nil)
    @org1.save!
    @org2 = FactoryGirl.build(:organization, :name => 'Indian Elders Association',
                              :description => 'Care for the elderly', :address => '62 pinner road', :postcode => 'HA1 3RE', :donation_info => 'www.indian-elders.co.uk/donate')
    @org2.categories << @category1
    @org2.categories << @category2
    @org2.save!
    @org3 = FactoryGirl.build(:organization, :name => 'Age UK Elderly', :description => 'Care for older people', :address => '62 pinner road', :postcode => 'HA1 3RE', :donation_info => 'www.age-uk.co.uk/donate')
    @org3.categories << @category1
    @org3.save!
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
    expect(Organization).to respond_to(:filter_by_category)
  end

  it 'finds all orgs in a particular category' do
    expect(Organization.filter_by_category("1")).not_to include @org1
    expect(Organization.filter_by_category("1")).to include @org2
    expect(Organization.filter_by_category("1")).to include @org3
  end

  it 'finds all orgs when category is nil, and returns ActiveRecord::Relation to keep kaminari happy' do
    expect(Organization.filter_by_category(nil)).to include(@org1)
    expect(Organization.filter_by_category(nil)).to include(@org2)
    expect(Organization.filter_by_category(nil)).to include(@org3)
    expect(Organization.filter_by_category(nil).class).to eq ActiveRecord::Relation
  end

  it 'should have and belong to many categories' do
    expect(@org2.categories).to include(@category1)
    expect(@org2.categories).to include(@category2)
  end

  it 'must have search by keyword' do
    expect(Organization).to respond_to(:search_by_keyword)
  end

  it 'find all orgs that have keyword anywhere in their name or description' do
    expect(Organization.search_by_keyword("elderly")).to eq([@org2, @org3])
  end

  it 'searches by keyword and filters by category and has zero results' do
    result = Organization.search_by_keyword("Harrow").filter_by_category("1")
    expect(result).not_to include @org1, @org2, @org3
  end

  it 'searches by keyword and filters by category and has results' do
    result = Organization.search_by_keyword("Indian").filter_by_category("1")
    expect(result).to include @org2
    expect(result).not_to include @org1, @org3
  end

  it 'searches by keyword when filter by category id is nil' do
    result = Organization.search_by_keyword("Harrow").filter_by_category(nil)
    expect(result).to include @org1
    expect(result).not_to include @org2, @org3
  end

  it 'filters by category when searches by keyword is nil' do
    result = Organization.search_by_keyword(nil).filter_by_category("1")
    expect(result).to include @org2, @org3
    expect(result).not_to include @org1
  end

  it 'returns all orgs when both filter by category and search by keyword are nil args' do
    result = Organization.search_by_keyword(nil).filter_by_category(nil)
    expect(result).to include @org1, @org2, @org3
  end

  it 'handles weird input (possibly from infinite scroll system)' do
    # Couldn't find Category with id=?test=0
    expect(lambda {Organization.filter_by_category("?test=0")} ).not_to raise_error
  end

  it 'has users' do
    expect(@org1).to respond_to(:users)
  end

  it 'can humanize with all first capitals' do
    expect("HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW".humanized_all_first_capitals).to eq("Harrow Baptist Church, College Road, Harrow")
  end

  describe 'Creating of Organizations from CSV file' do
    before(:all){ @headers = 'Title,Charity Number,Activities,Contact Name,Contact Address,website,Contact Telephone,date registered,date removed,accounts date,spending,income,company number,OpenlyLocalURL,twitter account name,facebook account name,youtube account name,feed url,Charity Classification,signed up for 1010,last checked,created at,updated at,Removed?'.split(',')}

    it 'must not override an existing organization' do
      fields = CSV.parse('INDIAN ELDERS ASSOCIATION,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH,COLLEGE ROAD, HARROW, HA1 1BA",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      org = create_organization(fields)
      expect(org).to be_nil
    end

    it 'must not create org when date removed is not nil' do
      fields = CSV.parse('HARROW BAPTIST CHURCH,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,2009-05-28,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      org = create_organization(fields)
      expect(org).to be_nil
    end

    # the following 6 or so feel more like integration tests than unit tests
    # TODO should they be moved into another file?  OR MAYBE TO CUCUMBER???
    it 'must be able to generate multiple Organizations from text file' do
      mock_org = double("org")
      [:name, :name=, :description=, :address=, :postcode=, :website=, :telephone=].each do |method|
        mock_org.stub(method)
      end
      Organization.stub(:find_by_name).and_return nil
      attempted_number_to_import = 1006
      actual_number_to_import = 642
      time = Time.now
      Organization.should_receive(:new).exactly(actual_number_to_import).and_return mock_org
      rows_to_parse = (1..attempted_number_to_import).collect do |number|
          hash_to_return = {}
          hash_to_return.stub(:header?){true}
          hash_to_return[Organization.column_mappings[:name]] = "Test org #{number}"
          hash_to_return[Organization.column_mappings[:address]] = "10 Downing St London SW1A 2AA, United Kingdom"
        if(actual_number_to_import < number)
           hash_to_return[Organization.column_mappings[:date_removed]] = time
        end

        hash_to_return
      end
      mock_file_handle = double("file")
      File.should_receive(:open).and_return(mock_file_handle)
      CSV.should_receive(:parse).with(mock_file_handle, :headers => true).and_return rows_to_parse
      mock_org.should_receive(:save!).exactly(actual_number_to_import)
      Organization.import_addresses 'db/data.csv', attempted_number_to_import

    end

    it 'must fail gracefully when encountering error in generating multiple Organizations from text file' do
      attempted_number_to_import = 1006
      actual_number_to_import = 642
      Gmaps4rails.should_receive(:geocode).exactly(0)
      Organization.stub(:create_from_array).and_raise(CSV::MalformedCSVError)
      expect(lambda {
        Organization.import_addresses 'db/data.csv', attempted_number_to_import
      }).to change(Organization, :count).by(0)
    end

    it 'must be able to handle no postcode in text representation' do
      Gmaps4rails.should_receive(:geocode)
      fields = CSV.parse('HARROW BAPTIST CHURCH,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      org = create_organization(fields)
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
      org = create_organization(fields)
      expect(org.name).to eq('Harrow Baptist Church')
      expect(org.description).to eq('No information recorded')
      expect(org.address).to eq('')
      expect(org.postcode).to eq('')
      expect(org.website).to eq('http://www.harrow-baptist.org.uk')
      expect(org.telephone).to eq('020 8863 7837')
      expect(org.donation_info).to eq(nil)
    end

    it 'must be able to generate Organization from text representation ensuring words in correct case and postcode is extracted from address' do
      Gmaps4rails.should_receive(:geocode)
      fields = CSV.parse('HARROW BAPTIST CHURCH,1129832,NO INFORMATION RECORDED,MR JOHN ROSS NEWBY,"HARROW BAPTIST CHURCH, COLLEGE ROAD, HARROW, HA1 1BA",http://www.harrow-baptist.org.uk,020 8863 7837,2009-05-27,,,,,,http://OpenlyLocal.com/charities/57879-HARROW-BAPTIST-CHURCH,,,,,"207,305,108,302,306",false,2010-09-20T21:38:52+01:00,2010-08-22T22:19:07+01:00,2012-04-15T11:22:12+01:00,*****')
      org = create_organization(fields)
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
        org = create_organization(fields)
      }).to raise_error
    end


    def create_organization(fields)
      row = CSV::Row.new(@headers, fields.flatten)
      Organization.create_from_array(row, true)
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
        @org4 = FactoryGirl.build(:organization, :name => 'Fellowship For Management In Food Distribution', :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 3TE', :donation_info => 'www.harrow-bereavment.co.uk/donate')
        Gmaps4rails.should_receive(:geocode)
        @org4.save!
        [102,206,302].each do |id|
          FactoryGirl.build(:category, :charity_commission_id => id).save!
        end
        attempted_number_to_import = 2
        number_cat_org_relations_generated = 3
        expect(lambda {
          Organization.import_category_mappings 'db/data.csv', attempted_number_to_import
        }).to change(CategoryOrganization, :count).by(number_cat_org_relations_generated)
      end

      it "allows us to import categories" do
        org = Organization.import_categories_from_array(row)
        expect(org.categories.length).to eq 5
        [207,305,108,302,306].each do |id|
          expect(org.categories).to include(Category.find_by_charity_commission_id(id))
        end
      end

      it 'must fail gracefully when encountering error in importing categories from text file' do
        attempted_number_to_import = 2
        Organization.stub(:import_categories_from_array).and_raise(CSV::MalformedCSVError)
        expect(lambda {
          Organization.import_category_mappings 'db/data.csv', attempted_number_to_import
        }).to change(Organization, :count).by(0)
      end

      it "should import categories when matching org is found" do
        Organization.should_receive(:check_columns_in).with(row)
        Organization.should_receive(:find_by_name).with('Harrow Bereavement Counselling').and_return @org1
        array = double('Array')
        [{:cc_id => 207, :cat => @cat1}, {:cc_id => 305, :cat => @cat2}, {:cc_id => 108, :cat => @cat3},
         {:cc_id => 302, :cat => @cat4}, {:cc_id => 306, :cat => @cat5}]. each do |cat_hash|
          Category.should_receive(:find_by_charity_commission_id).with(cat_hash[:cc_id]).and_return(cat_hash[:cat])
          array.should_receive(:<<).with(cat_hash[:cat])
        end
        @org1.should_receive(:categories).exactly(5).times.and_return(array)
        org = Organization.import_categories_from_array(row)
        expect(org).not_to be_nil
      end

      it "should not import categories when no matching organization" do
        Organization.should_receive(:check_columns_in).with(row)
        Organization.should_receive(:find_by_name).with('Harrow Bereavement Counselling').and_return nil
        org = Organization.import_categories_from_array(row)
        expect(org).to be_nil
      end

      it "should not import categories when none are listed" do
        Organization.should_receive(:check_columns_in).with(row_cat_missing)
        Organization.should_receive(:find_by_name).with('Harrow Bereavement Counselling').and_return @org1
        org = Organization.import_categories_from_array(row_cat_missing)
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
    org = FactoryGirl.build(:organization,:address => address, :postcode => postcode, :name => 'Happy and Nice', :gmaps => true)
    org.save
  end

  #TODO: refactor with expect{} instead of should as Rspec 2 promotes
  it 'should delete geocoding errors and save organization' do
    new_address = '777 pinner road'
    @org1.latitude = 77
    @org1.longitude = 77
    Gmaps4rails.should_receive(:geocode).and_raise(Gmaps4rails::GeocodeInvalidQuery)
    @org1.address = new_address
    @org1.update_attributes :address => new_address
    @org1.errors['gmaps4rails_address'].should be_empty
    actual_address = Organization.find_by_name(@org1.name).address
    expect(actual_address).to eq(new_address)
    expect(@org1.latitude).to be_nil
    expect(@org1.longitude).to be_nil
  end

  it 'should not delete validation errors unrelated to gmap4rails address issues' do
    Organization.class_eval do
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
    actual_address = Organization.find_by_name(@org1.name).address
    expect(actual_address).to eq(new_address)
  end
  # not sure if we need SQL injection security tests like this ...
  # org = Organization.new(:address =>"blah", :gmaps=> ";DROP DATABASE;")
  # org = Organization.new(:address =>"blah", :name=> ";DROP DATABASE;")

  describe "importing emails" do
    it "should have a method import_emails" do
      Organization.should_receive(:add_email)
      Organization.should_receive(:import).with(nil,2,false) do |&arg|
        Organization.add_email(&arg)
      end
      Organization.import_emails(nil,2,false)
    end
    it 'should handle absence of org gracefully' do
      Organization.should_receive(:where).with("UPPER(name) LIKE ? ", "%I LOVE PEOPLE%").and_return(nil)
      STDOUT.should_receive(:puts).with("i love people was not found")
      expect(lambda{
        Organization.add_email(fields = CSV.parse('i love people,,,,,,,test@example.org')[0],true)
      }).not_to raise_error
      
    end
    it "should add email to org" do
      Organization.should_receive(:where).with("UPPER(name) LIKE ? ", "%FRIENDLY%").and_return([@org1])
      @org1.should_receive(:email=).with('test@example.org')
      @org1.should_receive(:save)
      Organization.add_email(fields = CSV.parse('friendly,,,,,,,test@example.org')[0],true)
    end

    it "should add email to org even with case mismatch" do
      Organization.should_receive(:where).with("UPPER(name) LIKE ? ", "%FRIENDLY%").and_return([@org1])
      @org1.should_receive(:email=).with('test@example.org')
      @org1.should_receive(:save)
      Organization.add_email(fields = CSV.parse('friendly,,,,,,,test@example.org')[0],true)
    end

    it 'should not add email to org when it has an existing email' do
      @org1.email = 'something@example.com'
      @org1.save!
      Organization.should_receive(:where).with("UPPER(name) LIKE ? ", "%FRIENDLY%").and_return([@org1])
      @org1.should_not_receive(:email=).with('test@example.org')
      @org1.should_not_receive(:save)
      Organization.add_email(fields = CSV.parse('friendly,,,,,,,test@example.org')[0],true)
    end
  end

end
