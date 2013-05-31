require 'spec_helper'
 
describe CharityWorker do
  before :suite do
    FactoryGirl.factories.clear
    FactoryGirl.find_definitions
  end
  before :each do
    FactoryGirl.build(:charity_worker, :email => 'jj@example.com', 
      :password => 'pppppppp', :admin => true).save!
    FactoryGirl.build(:charity_worker, :email => 'jj1@example.com', 
      :password => 'pppppppp', :admin => true).save!
    FactoryGirl.build(:charity_worker, :email => 'jj2@example.com', 
      :password => 'pppppppp', :admin => false).save!
  end
  it 'must find an admin in find_by_admin with true argument' do
    @result = CharityWorker.find_by_admin(true)
    expect(@result.admin?).to be_true
  end
  it 'must find a non-admin in find_by_admin with false argument' do
    @result = CharityWorker.find_by_admin(false)
    expect(@result.admin?).to be_false
  end
end
