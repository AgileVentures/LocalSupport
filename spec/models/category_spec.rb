require 'rails_helper'

describe 'Category', :type => :model do

  context 'scopes' do
    let!(:category_array){[["education", 100], ["sports", 199], ["children", 200], ["youth", 299], ["advocacy", 300], ["umbrella", 399]]}
    before do
      category_array.each do | name, charity_commission_id |
        create(:category, charity_commission_id: charity_commission_id, name: name)
      end
    end

    describe "self.name_and_id_for_what_who_and_how" do
      subject { Category.name_and_id_for_what_who_and_how }
      it { expect(subject[:what].count).to eq(2)}
      it { expect(subject[:who].count).to eq(2) }
      it { expect(subject[:how].count).to eq(2) }
      it { expect(subject[:what]).to include [Category.find_by(charity_commission_id: 100).name, Category.find_by(charity_commission_id: 100).id]}
      it { expect(subject[:what]).to include [Category.find_by(charity_commission_id: 199).name, Category.find_by(charity_commission_id: 199).id]}
      it { expect(subject[:who]).to include [Category.find_by(charity_commission_id: 200).name, Category.find_by(charity_commission_id: 200).id]}
      it { expect(subject[:who]).to include [Category.find_by(charity_commission_id: 299).name, Category.find_by(charity_commission_id: 299).id]}
      it { expect(subject[:how]).to include [Category.find_by(charity_commission_id: 300).name, Category.find_by(charity_commission_id: 300).id]}
      it { expect(subject[:how]).to include [Category.find_by(charity_commission_id: 399).name, Category.find_by(charity_commission_id: 399).id]}
    end

    describe 'self.what_they_do' do
      subject { Category.what_they_do }
      it { expect(subject.count).to eq 2 }
      it { expect(subject.pluck(:charity_commission_id)).to include 100, 199 }
    end

    describe 'self.who_they_help' do
      subject { Category.who_they_help }
      it { expect(subject.count).to eq 2 }
      it { expect(subject.pluck(:charity_commission_id)).to include 200, 299 }
    end

    describe 'self.how_they_help' do
      subject { Category.how_they_help }
      it { expect(subject.count).to eq 2 }
      it { expect(subject.pluck(:charity_commission_id)).to include 300, 399 }
    end
  end


  context do
    before do
      FactoryGirl.factories.clear
      FactoryGirl.find_definitions
      @category1 = FactoryGirl.create(:category, name: "alligator",  charity_commission_id: 100)
      @category4 = FactoryGirl.create(:category, name: "capybara",  charity_commission_id: 101)
      @category2 = FactoryGirl.create(:category, name: "crocodile", charity_commission_id: 210)
      @category5 = FactoryGirl.create(:category, name: "guinea pig", charity_commission_id: 201)
      @category3 = FactoryGirl.create(:category, name: "iguana", charity_commission_id: 310)
      @category6 = FactoryGirl.create(:category, name: "rabbit", charity_commission_id: 304)
      @org1 = FactoryGirl.build(:organisation, :name => 'Harrow Bereavement Counselling', :description => 'Bereavement Counselling', :address => '64 pinner road', :postcode => 'HA1 4HZ', :donation_info => 'www.harrow-bereavment.co.uk/donate')
      allow(@org1).to receive :geocode
      @org1.save!
      @org2 = FactoryGirl.build(:organisation, :name => 'Indian Elders Associaton', :description => 'Care for the elderly', :address => '64 pinner road', :postcode => 'HA1 4HZ', :donation_info => 'www.indian-elders.co.uk/donate')
      allow(@org2).to receive :geocode
      @org2.categories << @category1
      @org2.categories << @category2
      @org2.save!
      @org3 = FactoryGirl.build(:organisation, :name => 'Age UK Elderly', :description => 'Care for older people', :address => '64 pinner road', :postcode => 'HA1 4HZ', :donation_info => 'www.age-uk.co.uk/donate')
      @org3.categories << @category1
      allow(@org3).to receive :geocode
      @org3.save!
    end

    it 'should have a human readable name and charity commission id and ridiculous name' do
      c = Category.new(:name => "Health",:charity_commission_id => 1, :charity_commission_name => "WELL BEING AND JOYOUS EXISTENCE")
      expect(c.name).to eq("Health")
      expect(c.charity_commission_id).to eq(1)
      expect(c.charity_commission_name).to eq("WELL BEING AND JOYOUS EXISTENCE")
    end

    it 'has and belongs to many base_organisations' do
      expect(@category1.base_organisations).to include(@org2)
      expect(@category1.base_organisations).to include(@org3)
    end

    it 'should have a seed method' do
      expect(Category).to respond_to :seed
    end

    it 'must generate categories' do
      num_of_categories = 34
      expect(lambda {
        Category.seed 'db/charity_classifications.csv'
      }).to change(Category, :count).by(num_of_categories)
      Category.all.each do |cat|
        expect(cat.charity_commission_id).not_to be_nil
        expect(cat.charity_commission_name).not_to be_nil
        expect(cat.name).not_to be_nil
        expect(cat.charity_commission_name).to eq cat.charity_commission_name.strip
        expect(cat.name).to eq cat.name.strip
      end
    end

    describe "#<=>" do
      [{type: "what they do", id: 110}, {type: "who they help", id: 210}, {type: "how they help", id: 310}].each do |hash|
        it "orders by name when category types are both #{hash[:type]}" do
          alligator = Category.new(charity_commission_id: hash[:id], name: "Alligator") 
          crocodile = Category.new(charity_commission_id: hash[:id] + 1, name: "Crocodile")
          expect(alligator<=>crocodile).to eq -1
        end
      end
      [{first_type: "what they do", first_id: 100, second_id: 200, second_type: "who they help", result: -1},
       {first_type: "who they help", first_id: 299, second_id: 399, second_type: "how they help", result: -1},
       {first_type: "what they do", first_id: 199, second_id: 399, second_type: "how they help", result: -1},
       {second_type: "what they do", second_id: 199, first_id: 200, first_type: "who they help", result: 1},
       {second_type: "who they help", second_id: 299, first_id: 300, first_type: "how they help", result: 1},
       {second_type: "what they do", second_id: 100, first_id: 300, first_type: "how they help", result: 1}].each do |hash|
         it "orders by type when the first category is #{hash[:first_type]} and the second category is #{hash[:second_type]}" do
           alligator = Category.new(charity_commission_id: hash[:first_id], name: "Alligator") 
           crocodile = Category.new(charity_commission_id: hash[:second_id], name: "Crocodile")
           expect(alligator<=>crocodile).to eq hash[:result] 
         end
       end
       it 'returns 0 when category types and names are the same' do
         alligator = Category.new(charity_commission_id: 310, name: "Alligator") 
         crocodile = Category.new(charity_commission_id: 310, name: "Alligator") 
         expect(alligator<=>crocodile).to eq 0
       end
    end
  end

end
