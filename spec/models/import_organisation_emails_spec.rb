require 'rails_helper'

describe Organisation, :type => :model do

  before do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions

    @org1 = FactoryGirl.create(:organisation, :email => nil, :name => 'Harrow Bereavement Counselling', :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 3TE', :donation_info => 'www.harrow-bereavment.co.uk/donate')
    @org2 = FactoryGirl.create(:organisation, :email => nil,  :name => 'Indian Elders Association',
                              :description => 'Care for the elderly', :address => '64 pinner road', :postcode => 'HA1 3RE', :donation_info => 'www.indian-elders.co.uk/donate')
    @org3 = FactoryGirl.create(:organisation, :email => nil, :name => 'Age UK Elderly', :description => 'Care for older people', :address => '64 pinner road', :postcode => 'HA1 3RE', :donation_info => 'www.age-uk.co.uk/donate')
  end

  describe "importing emails" do
    it "should have a method import_emails" do
      filename = "db/emails.csv"
      expect(Organisation).to receive(:add_email).twice.and_call_original
      expect(Organisation).to receive(:import).with(filename,2,false).and_call_original
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
end