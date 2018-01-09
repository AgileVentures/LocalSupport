require 'rails_helper'

describe ClickThroughsController, type: :controller do

  it 'should redirect' do
    get :go_to, params: {url: 'https://www.google.com'}
    expect(response).to redirect_to 'https://www.google.com'
  end

  it 'should write a new click_through row' do
    expect {
      get :go_to, params: {url: 'https://www.google.com'}
    }.to change { ClickThrough.count }
  end
  
end