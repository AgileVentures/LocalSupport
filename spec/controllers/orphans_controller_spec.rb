require 'spec_helper'

describe OrphansController do
  it 'is for admins only' do
    user = double('User', :admin? => false)
    controller.stub(:current_user).and_return(user)
    get :index
    response.should redirect_to '/'
    post :create, {}
    response.should redirect_to '/'
  end
end