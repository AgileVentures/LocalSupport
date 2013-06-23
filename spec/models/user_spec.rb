require 'spec_helper'
 
describe User do
  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
  end
  before :each do
    @admin = FactoryGirl.build(:user, :email => 'jj@example.com',
      :password => 'pppppppp', :admin => true)  
    @admin.save!
    FactoryGirl.build(:user, :email => 'jj1@example.com',
      :password => 'pppppppp', :admin => true).save!
    @nonadmin = FactoryGirl.build(:user, :email => 'jj2@example.com',
      :password => 'pppppppp', :admin => false)
    @nonadmin.save!
  end
  it 'must find an admin in find_by_admin with true argument' do
    @result = User.find_by_admin(true)
    expect(@result.admin?).to be_true
  end
  it 'must find a non-admin in find_by_admin with false argument' do
    @result = User.find_by_admin(false)
    expect(@result.admin?).to be_false
  end
  it 'lets admin edit any organization' do
    model = mock_model("Organization")
    expect(@admin.can_edit?(model)).to be_true 
  end
  it 'lets non-admin edit associated organization' do
    model = mock_model("Organization")
    @nonadmin.should_receive(:organization).and_return model
    expect(@nonadmin.can_edit?(model)).to be_true 
  end
  it 'does not let non-admin edit non-associated organization' do
    non_associated_model = mock_model("Organization")
    associated_model = mock_model("Organization")
    @nonadmin.should_receive(:organization).and_return associated_model
    expect(@nonadmin.can_edit?(non_associated_model)).to be_false
  end
  it 'does not let non-admin edit when associated with no org' do
    non_associated_model = mock_model("Organization")
    @nonadmin.should_receive(:organization).and_return nil
    expect(@nonadmin.can_edit?(non_associated_model)).to be_false
  end
  it 'does not allow mass assignment of admin for security' do
    @nonadmin.update_attributes(:admin=> true)
    @nonadmin.save!
    expect(@nonadmin.admin).to be_false
  end
end
