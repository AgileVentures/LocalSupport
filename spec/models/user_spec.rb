require 'spec_helper'
 
describe User do

  let (:model) { mock_model("Organization") }
  
  it 'must find an admin in find_by_admin with true argument' do
    FactoryGirl.create(:user, admin: true)
    result = User.find_by_admin(true)
    result.admin?.should be_true
  end

  it 'must find a non-admin in find_by_admin with false argument' do
    FactoryGirl.create(:user, admin: false ) 
    result = User.find_by_admin(false)
    result.admin?.should be_false
  end

  context 'is admin' do
    subject { create(:user, admin: true) }  
    
    it 'can edit organizations' do
      subject.can_edit?(model).should be_true 
    end

  end
  
  context 'is not admin' do 
    
    let( :non_associated_model ) { mock_model("Organization") }
    
    subject { create(:user, admin: false ) } 

    it 'can edit associated organization' do
      should_receive(:organization).and_return model
      subject.can_edit?(model).should be_true 
    end
    
    it 'can not edit non-associated organization' do
      should_receive(:organization).and_return model
      subject.can_edit?(non_associated_model).should be_false
    end
    
    it 'can not edit when associated with no org' do
      should_receive(:organization).and_return nil
      subject.can_edit?(non_associated_model).should be_false
    end

    it 'can not edit when associated with no org and attempting to access non-existent org' do
      subject.can_edit?(nil).should be_false
    end

    it 'does not allow mass assignment of admin for security' do
      subject.update_attributes(:admin=> true)
      subject.save!
      subject.admin.should be_false
    end

  end
end
