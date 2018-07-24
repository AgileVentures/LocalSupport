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
        expect(res).to eq('f7011d0d-2764-4a2c-a0a2-d66433ae49ad')
      end

      it 'handles 400 error responses' do
        stub_request(:post, "http://api.qa2.do-it.org/v2/opportunities").
          to_return(:status => 401, :body => File.read('test/fixtures/doit_response_with_error_message.json'), :headers => {'Content-Type' => 'application/json'})
        vol_op = build :volunteer_op,
                       latitude: '51.5676116',
                       longitude: '-0.3580085'
        res = Doit::PostToDoit.call volunteer_op: vol_op,
                                    advertise_start_date: Date.current.strftime('%F'),
                                    advertise_end_date: Date.tomorrow.strftime('%F'),
                                    doit_org_id: '4dd7dfe2-c281-4170-8f0b-da17e8af5e5d'
        expect(res).to be true  # Rails.logger returns true
      end
    end
  end
end
