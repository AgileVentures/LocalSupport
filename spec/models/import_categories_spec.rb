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
    @org1 = FactoryGirl.create(:organisation, :email => nil, :name => 'Harrow Bereavement Counselling', :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 3TE', :donation_info => 'www.harrow-bereavment.co.uk/donate')
    @org2 = FactoryGirl.build(:organisation, :email => nil,  :name => 'Indian Elders Association',
                              :description => 'Care for the elderly', :address => '64 pinner road', :postcode => 'HA1 3RE', :donation_info => 'www.indian-elders.co.uk/donate')
    @org2.categories << @category1
    @org2.categories << @category2
    @org2.save!
    @org3 = FactoryGirl.build(:organisation, :email => nil, :name => 'Age UK Elderly', :description => 'Care for older people', :address => '64 pinner road', :postcode => 'HA1 3RE', :donation_info => 'www.age-uk.co.uk/donate')
    @org3.categories << @category1
    @org3.save!
    @headers = 'Title,Charity Number,Activities,Contact Name,Contact Address,website,Contact Telephone,date registered,date removed,accounts date,spending,income,company number,OpenlyLocalURL,twitter account name,facebook account name,youtube account name,feed url,Charity Classification,signed up for 1010,last checked,created at,updated at,Removed?'.split(',')
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