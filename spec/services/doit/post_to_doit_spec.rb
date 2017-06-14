require 'rails_helper'

module Doit
  RSpec.describe PostToDoit do
    
    describe '.call' do
      it 'create a volunteer op in Doit' do
        stub_request(:post, "http://api.qa2.do-it.org/v2/opportunities").
          to_return(:status => 200, :body => File.read('test/fixtures/doit_post_volop.json'), :headers => {'Content-Type' => 'application/json'})
        vol_op = build(:volunteer_op,
                       latitude: '51.5676116',
                       longitude: '-0.3580085')
        res = Doit::PostToDoit.call(volunteer_op: vol_op,
                                   advertise_start_date: '2017-01-01',
                                   advertise_end_date: '2017-03-01',
                                   doit_org_id: '4dd7dfe2-c281-4170-8f0b-da17e8af5e5d')
        expect(res).to be_truthy
      end
    end

    describe 'env var' do
      it 'must be displayed!!' do
        p "DOit host: #{ENV['DOIT_HOST']}"
        p "Auth token: #{ENV['DOIT_AUTH_TOKEN']}"
      end
    end
  end
end
