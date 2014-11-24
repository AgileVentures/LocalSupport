require 'rails_helper'
require 'custom_errors.rb'

describe CustomErrors, type: :controller do
  controller(ApplicationController) do
    include CustomErrors

    def raise_404
      raise ActiveRecord::RecordNotFound
    end

    def raise_500
      raise Exception
    end
  end

  before(:each) do
    allow(Rails).to receive_message_chain(:env, :production?).and_return(true)
  end

  context '404 errors' do
    before(:each) do
      routes.draw { get 'raise_404' => 'anonymous#raise_404' }
    end

    it 'should catch 404 errors' do

      get :raise_404
      expect(response).to render_template 'pages/404'
      expect(response.status).to eq 404
    end
  end

  context '500 errors' do
    before(:each) do
      routes.draw { get 'raise_500' => 'anonymous#raise_500' }
    end

    it 'should catch 500 errors' do
      get :raise_500
      expect(response).to render_template 'pages/500'
      expect(response.status).to eq 500
    end

    it 'should be able to adjust log stack trace limit' do
      expect(Rails.logger).to receive(:error).exactly(7)
      get :raise_500
    end
  end
end
